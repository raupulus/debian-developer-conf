#!/usr/bin/env python
# -*- coding: utf-8 *-*
"""
This module provides objects to manage the execution of the debugger.
"""

import os
import Queue
import sys
import time
import threading

THREAD_START = "THREAD_STARTED"
THREAD_PAUSE = "THREAD_PAUSE"
THREAD_RESUME = "THREAD_RESUME"
THREAD_STOP = "THREAD_STOP"

class NdbThread:
    """
    NdbThread class represents a Thread in the debugging session. Every
    thread (including MainThread) has a corresponding object. An object of this
    class exposes methods to control its execution.
    """
    # Commands
    CMD_RUN = "Run"
    CMD_STEP_OVER = "Over"
    CMD_STEP_INTO = "Into"
    CMD_STEP_OUT = "Out"

    def __init__(self, tid, name, frame, debugger, events_handler = None):
        """
        Create a new NdbThread from a frame with an id and a name.

        def events_hanlder(id, ndbthread)
        """
        self.id = tid
        self.name = name
        self._f_origin = frame
        self.current_frame = frame
        self._f_stop = None
        self._f_cmd = NdbThread.CMD_RUN
        self.state = 'running'
        self.debugger = debugger

        # Default handler
        self.events_handler = lambda x: None
        if events_handler:
            self.events_handler = events_handler

        # Handle thread created event
        self.events_handler(THREAD_START, self)

    def trace_dispatch(self, frame, event, arg):
        """
        Analyze a given frame and event in the trace. Stop waiting for
        events when a stop is appropriate.
        """
        # Returning from origin frame, means thread is finishing.
        if event == 'return' and frame == self._f_origin:
            self.stop()
            return None

        if not self._f_origin:
            return None

        # Set current frame
        self.current_frame = frame

        # Get the "stop frame". This stop frame may not be the same as the one
        # we are "executing" for example for returns we stop on the caller.
        s_frame = self._stop_frame(frame, event)
        if s_frame:
            self.state = 'paused'
            self._wait()

        f_path = frame.f_code.co_filename
        f_line = frame.f_lineno

        # Return trace function
        return self.trace_dispatch

    def _stop_frame(self, frame, event):
        """
        Return the corresponding stop frame for the current position (defined
        by frame) and event. Return None when we don't have to stop.
        """
        if event is 'return':
            # Depending on the kind of command we have, we should check if this
            # is a stopping point. Always return the upper frame on a return.
            if self._f_cmd is NdbThread.CMD_STEP_INTO:
                self.current_frame = frame.f_back
                return frame.f_back

            stops = [NdbThread.CMD_STEP_OVER, NdbThread.CMD_STEP_OUT]
            if self._f_cmd in stops and frame is self._f_stop:
                self.current_frame = frame.f_back
                return frame.f_back

        if event is 'line':
            if self._f_cmd is NdbThread.CMD_STEP_INTO:
                return frame
            if self._f_cmd is NdbThread.CMD_STEP_OVER:
                if frame is self._f_stop:
                    return frame

        # If we've hit a breakpoint we should stop at the current frame
        f_path = frame.f_code.co_filename
        f_line = frame.f_lineno

        if self.debugger.breakpoint_manager.check(f_path, f_line):
            return frame
        return None

    def _wait(self):
        """Stop the thread until the status change to other than PAUSED."""
        # Handle thread pause event
        self.events_handler(THREAD_PAUSE, self)
        # Wait for state to change
        while self.state == 'paused':
            time.sleep(0.1)

    def name(self):
        """Return the name of the NdbThread."""
        return self._name

    def state(self):
        """Return the state of the NdbThread."""
        return self.state

    def stop(self):
        """Make the current thread stop executing."""
        # Notify about this thread being terminated.
        if self._f_origin:
            # Handle thread stop event
            self.events_handler(THREAD_STOP, self)
        # Clear thread info
        self._f_origin = None
        self.current_frame = None # Release current frame
        self._f_stop = None
        self._f_cmd = None
        self.state = None

    def _continue(self, command, stop):
        """Continue execution with the specified command."""
        if self._f_origin:
            # Set stop information
            self._f_stop = stop
            self._f_cmd = command
            self.state = 'running'
            # Handle thread resume event
            self.events_handler(THREAD_RESUME, self)
        return self.state

    def resume(self):
        """Make this thread resume execution after a stop."""
        return self._continue(NdbThread.CMD_RUN, None)

    def step_over(self):
        """Stop on the next line in the current frame."""
        return self._continue(NdbThread.CMD_STEP_OVER, self.current_frame)

    def step_into(self):
        """Stop execution at the next line of code."""
        return self._continue(NdbThread.CMD_STEP_INTO, None)

    def step_out(self):
        """Stop execution after the return of the current frame."""
        return self._continue(NdbThread.CMD_STEP_OUT, self.current_frame)

    def get_stack(self):
        """
        Return an array of tuples with the file names and line numbers of
        each entry in the stack. The first entry is the upper frame.
        """
        stack = []
        # Add all frames in the stack to the result
        index_f = self.current_frame
        while index_f is not None:
            f_name = os.path.basename(index_f.f_code.co_filename)
            f_line = index_f.f_lineno
            stack.insert(0, (f_name, f_line))
            index_f = index_f.f_back
        return stack

    def get_frame(self):
        """Return the frame of current execution."""
        return self.current_frame

    def evaluate(self, expr):
        """
        Evaluate an expression in the context of the current thread and return
        its value. The expression cannot contains assignments.
        """
        try:
            result = eval(expr, self.current_frame.f_globals,
                          self.current_frame.f_locals)
        except SyntaxError as serr:
            result = serr
        except Exception as err:
            result = err
        return result

    def execute(self, expr):
        """
        Execute an expression in the context of the current thread and return
        its value.
        """
        try:
            # Compile and execute code
            c_code = compile(source=expr, filename="<string>", mode='exec')
            exec c_code in self.current_frame.f_globals, self.current_frame.f_locals
            result = ""
        except SyntaxError as serr:
            result = serr
        except Exception as err:
            result = err
        return result
