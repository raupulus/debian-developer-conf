#!/usr/bin/env python
# -*- coding: utf-8 *-*
"""
This module provides objects to manage the execution of the debugger.
"""

import os
import Queue
import sys
import threading
import time

# Ndb3 imports
import process
import threads
import breakpoints
import rpc
import events

# Debugger internal data
_IGNORE_FILES = ['threading.py', 'process.py', 'ndb3.py', 'serialize.py', 'rpc.py']


class Ndb3(object):
    """
    Ndb3 Class that manages the debugging session. Allows to stop, resume
    and start execution of debugged code.
    """

    def __init__(self, sourcefile):
        """
        Creates a new Ndb3 debugger. By default the debugger will start paused
        and waiting to be set on running.
        """
        self.sourcefile = sourcefile
        self.messages = Queue.Queue()
        self.breakpoint_manager = breakpoints.BreakpointManager()
        self._stop = True
        self.channel = None
        # Translation table from normalized ids to real ids.
        self.norm_ids = dict()

    def listen(self, port):
        """
        Set the debugger communication interface in listening mode on the
        specified port.
        """
        # XXX: TODO: Rename RPCDebuggerAdapter to RPCDebuggerChannel
        self.channel = rpc.RPCDebuggerAdapter(self, port)
        self.channel.start()

    def stop(self):
        """
        Stop execution of the debugged code. Terminate all running threads.
        """
        self._stop = True
        # Resume all threads XXX: TODO:
        for t in self.get_threads():
            t.resume()
        # Kill communications
        self.channel.quit()

    def start(self):
        """Start debugging session."""
        self._stop = False

    def run(self):
        """
        Starts execution of the script in a clean environment (or at least
        as clean as we can provide).
        """
        # Wait until we're good to go (start)
        while self._stop:
            time.sleep(0.1)

        # Generate end event
        msg = events.EventFactory.make_debug_start()
        self.messages.put(msg)

        try:
            # Set tracing...
            threading.settrace(self._trace_dispatch)
            sys.settrace(self._trace_dispatch)

            # Execute file
            process.runfile(self.sourcefile)

            # UnSet tracing...
            threading.settrace(None)
            sys.settrace(None)
        except Exception as e:
            print "Exception at debug: " + repr(e)

        # Remove tracing
        threading.settrace(None)
        sys.settrace(None)

        try:
            # Wait for all threads to finish.
            # XXX: TODO: This approach seems slow... needs improvement
            while len([self.get_threads()]) > 1 and not self._stop:
                time.sleep(0.5)
        finally:
            # Generate end event
            msg = events.EventFactory.make_debug_end()
            self.messages.put(msg)

    def _trace_dispatch(self, frame, event, arg):
        """
        Initial trace method. Create the NdbThread if it's a new thread
        or detour the trace to the corresponding thread.
        """
        if event not in ['call', 'line', 'return', 'exception']:
            return None

        filename = os.path.basename(frame.f_code.co_filename)
        if event == 'call' and filename in _IGNORE_FILES:
            return None

        if self._stop:
            return None

        # Get current thread id
        t = threading.currentThread()

        # If for some reason the thread is dead, don't trace
        if not t.isAlive():
            return None

        # Thread was already decorated?
        if not hasattr(t, 'ndb_info'):
            #  Normalize id to string to avoid issue #5
            norm_tid = str(t.ident)
            t.ndb_info = threads.NdbThread(norm_tid, t.name, frame,
                                          debugger=self,
                                          events_handler=self._on_thread_event)
            self.norm_ids[norm_tid] = t.ident

        # Return the trace function for this new scope
        return t.ndb_info.trace_dispatch(frame, event, arg)

    def _on_thread_event(self, event, thread):
        """Process event from the threads."""
        msg = None
        if event == threads.THREAD_START:
            msg = events.EventFactory.make_thread_create(thread)
        if event == threads.THREAD_PAUSE:
            msg = events.EventFactory.make_thread_pause(thread)
        if event == threads.THREAD_RESUME:
            msg = events.EventFactory.make_thread_resume(thread)
        if event == threads.THREAD_STOP:
            msg = events.EventFactory.make_thread_stop(thread)
        if msg:
            self.messages.put(msg)

    def get_thread(self, t_id):
        """Return the NdbThread with id=t_id, None if it doesn't exists."""
        real_tid = self.norm_ids.get(t_id)
        t = threading._active.get(real_tid, None)
        info = None
        if hasattr(t, 'ndb_info') and t.ndb_info.state != None:
            info = t.ndb_info
        return info

    def get_threads(self):
        """
        Return all active NdbThreads. Returns an object that generates the
        list of threads.
        """
        for i in self.norm_ids:
            t = self.get_thread(i)
            if t:
                yield t

    def get_messages(self):
        """
        Return the debugger's available messages. Messages allow clients to
        know the current state of the debugging session.
        """
        result = []
        while not self.messages.empty():
            result.append(self.messages.get(block=True))
        return result


if __name__ == '__main__':
    if not sys.argv[1:]:
        print "File name is missing"
        raise SystemExit

    # Remove ourselves from the argv. (Try to be transparent to the script).
    del sys.argv[0]

    # Create debugger object for the file in the argv[0]. The rest of the
    # params is passed intact to the script.
    dbg = Ndb3(sys.argv[0])

    # Start communication interface API
    dbg.listen(8765)

    # Set script dirname as first lookup directory
    sys.path.insert(0, os.path.dirname(sys.argv[0]))

    try:
        # Start debugger
        dbg.run()
    except Exception as e:
        print "Exception at main ndb3 execution:\n" + repr(e)
