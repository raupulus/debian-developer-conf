#!/usr/bin/env python
# -*- coding: utf-8 *-*
"""
This module provides RPC interaction with the debugger.
"""

import logging
from SimpleXMLRPCServer import SimpleXMLRPCServer
import socket
import threading
import xmlrpclib

import serialize


class DebuggerConnectionError(Exception):
    pass


class RPCDebuggerAdapter(threading.Thread, SimpleXMLRPCServer):
    """
    Adapter class that receives input from a RPC-channel and routes those
    requests to the debugger. This interface exports thru RPC only the methods
    beggining with "export_".
    """
    api_version = "0.2"

    def __init__(self, debugger, port=8765):
        """
        Create a new RPCDebuggerAdapter instance. Allow external users
        to interact with the debugger through XML-RPC.
        """
        threading.Thread.__init__(self, name=str(self.__class__))
        SimpleXMLRPCServer.__init__(self, ("", port),
                                    logRequests=False,
                                    allow_none=True)

        self.logger = logging.getLogger(__name__)
        self._quit = False
        self._debugger = debugger

    def _dispatch(self, method, params):
        """
        Return the function associated for the method specified. Return the
        function starting with "export_" + method to prevent potential security
        problems.
        """
        try:
            func = getattr(self, 'export_' + method)
        except AttributeError:
            raise Exception('method "%s" is not supported' % method)
        else:
            return func(*params)

    def run(self):
        """Start request handling loop."""
        while not self._quit:
            self.handle_request()

    def quit(self):
        """Stop the request handling loop."""
        self._quit = True

    def export_ping(self):
        """Return the current debugger version."""
        return self.api_version

    def export_start(self):
        """Start the debugger session. Return 'OK' if everything is fine."""
        self._debugger.start()
        return "OK"

    def export_stop(self):
        """Stop debugger session. ."""
        self._debugger.stop()
        return "OK"

    def export_resume(self, tid = None):
        """
        Resume execution of the specified thread. Stop execution only at
        breakpoints. Return the id of the thread resumed.
        """
        response = []
        if tid:
            t = self._debugger.get_thread(tid)
            t.resume()
            response.append(tid)
        else:
            for i in self._debugger.get_threads():
                i.resume()
                response.append(i.id)
        return response

    def export_step_over(self, tid):
        """
        Resume execution of the specified thread, but stop at the next
        line in the current frame of execution.
        """
        thread = self._debugger.get_thread(tid)
        thread.step_over()
        return str(tid)

    def export_step_into(self, tid):
        """
        Resume execution of the specified thread, but stop at the very next
        line of code, in or within the current frame.
        """
        thread = self._debugger.get_thread(tid)
        thread.step_into()
        return str(tid)

    def export_step_out(self, tid):
        """
        Resume execution of the specified thread, but stop after the return of
        the current frame.
        """
        thread = self._debugger.get_thread(tid)
        thread.step_out()
        return str(tid)

    def export_get_stack(self, tid):
        """Return the stack trace of the specified thread."""
        t_obj = self._debugger.get_thread(tid)
        return t_obj.get_stack()

    def export_set_breakpoint(self, filename, line):
        """Set the specified line in filename as a breakpoint."""
        self._debugger.breakpoint_manager.add(filename, line)
        return (filename, line)

    def export_clear_breakpoints(self, filename = None):
        """Clear breakpoints for a specified filename."""
        self._debugger.breakpoint_manager.remove(filename)
        return []

    def export_evaluate(self, tid, e_str, depth = 1):
        """
        Evaluate e_str in the context of the globals and locals from
        the execution frame in the specified thread.
        """
        t_obj = self._debugger.get_thread(tid)
        result = t_obj.evaluate(e_str)
        return serialize.serialize(e_str, e_str, result, depth=depth)

    def export_execute(self, tid, e_str):
        """
        Executes e_str in the context of the globals and locals from the
        execution frame in the specified thread.
        """
        t_obj = self._debugger.get_thread(tid)
        result = t_obj.execute(e_str)
        return serialize.serialize(e_str, e_str, result)

    def export_list_threads(self):
        """List the running threads."""
        t_list = []
        for t in self._debugger.get_threads():
            t_list.insert(0, (t.id, t.name, t.state))
        return t_list

    def export_get_messages(self):
        """Retrieve the list of unread messages of the debugger."""
        return self._debugger.get_messages()



class RPCDebuggerAdapterClient:
    """
    Threads safe class to control a Debugger using the RPCDebuggerAdapter.

    A RPCDebuggerAdapterClient object is used to control a RPCDebuggerAdapter
    thru RPC calls over the network.

    By default, the client will try to connect to localhost.

       +-------------+               +------------+          +--------+
       |  RPCClient  |+------------->| RPCAdapter |--------->|  Ndb3  |
       +-------------+    (RPC)      +------------+          +--------+

    """

    lock = threading.Lock()

    def __init__(self, host="localhost", port=8765):
        """Creates a new DebuggerMaster to handle a DebuggerSlave."""
        self.host = host
        self.port = port
        self.remote = None

    def __safe_call(self, func, *args):
        """
        Executes an RPC call to a non-threaded RPC server securely. This
        method uses a thread lock to ensure one call at a time.
        """
        if self.remote is None:
            return

        self.lock.acquire()
        try:
            return func(*args)
        except socket.error:
            raise DebuggerConnectionError("No connection could be made.")
        finally:
            self.lock.release()

    def connect(self, retries=1):
        """
        Connects to the remote end to start the debugging session. Returns True
        if connection is successful.
        """
        conn_str = "http://{0}:{1}".format(self.host, self.port)
        self.remote = xmlrpclib.Server(conn_str)
        while retries > 0:
            if self.is_alive():
                return True
            retries = retries - 1
        return False

    def disconnect(self):
        """
        Disconnect from the remote end. Always return True
        """
        self.remote = None
        return True

    def is_alive(self):
        """
        Check connectivity to the remote debugger. Try to make a RPC call,
        return False if connection was not successful.
        """
        try:
            self.__safe_call(self.remote.ping)
            return True
        except DebuggerConnectionError:
            pass
        except Exception:
            pass
        return False

    def start(self):
        """Start remote debugger execution of code."""
        return self.__safe_call(self.remote.start)

    def stop(self):
        """Stop debugger session and exit current execution."""
        return self.__safe_call(self.remote.stop)

    def resume(self, t_id):
        """Resume the execution of the specified debug thread."""
        return self.__safe_call(self.remote.resume, t_id)

    def resume_all(self):
        """Resume the execution of all debug threads."""
        return self.__safe_call(self.remote.resume)

    def step_over(self, t_id):
        """
        Stop execution of the specified debug thread on the next line of the
        same file or the parent context.
        """
        return self.__safe_call(self.remote.step_over, t_id)

    def step_into(self, t_id):
        """
        Stop execution of the specifed debug thread in the next instruction.
        """
        return self.__safe_call(self.remote.step_into, t_id)

    def step_out(self, t_id):
        """
        Resume execution of the specified debug thread until a return statement
        (implicit or explicit) is found.
        """
        return self.__safe_call(self.remote.step_out, t_id)

    def get_stack(self, t_id):
        """Return the list of files in the stack for the specifed thread."""
        return self.__safe_call(self.remote.get_stack, t_id)

    def set_breakpoint(self, filename, line):
        """Set a breakpoint in the specifed file and line."""
        return self.__safe_call(self.remote.set_breakpoint, filename, line)

    def clear_breakpoints(self, filename = None):
        """Clear all breakpoints for a specified filename."""
        return self.__safe_call(self.remote.clear_breakpoints, filename)

    def evaluate(self, t_id, e_str, depth = 1):
        """
        Evaluate the expression within the context of the specified debug
        thread. Since eval only evaluates expressions, a call to this method
        with an assignment will fail.

        For a deep understanding of the inner working of this method, see:
        http://docs.python.org/2/library/functions.html#eval.
        """
        return self.__safe_call(self.remote.evaluate, t_id, e_str, depth)

    def execute(self, t_id, e_str):
        """
        Execute an expression within the context of the specified debug thread.

        For a deep understanding of the inner working of this method, see:
        http://docs.python.org/2/reference/simple_stmts.html#exec.
        """
        return self.__safe_call(self.remote.execute, t_id, e_str)

    def list_threads(self):
        """Return the list of active threads on the remote debugger."""
        return self.__safe_call(self.remote.list_threads)

    def get_messages(self):
        """Return the list of available messages on the remote debugger."""
        return self.__safe_call(self.remote.get_messages)

