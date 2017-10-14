#!/usr/bin/env python
# -*- coding: utf-8 -*-

import threading
import json


class EventFactory:
    """Factory class to create debugger events."""

    def __init__(self):
        self.logger = logging.getLogger(__name__)

    @staticmethod
    def make_thread_create(thread):
        """
        Return a message with information about the thread that started its
        execution.
        """
        return {
            'type': 'THREAD_CREATE',
            'id': thread.id,
            'name': thread.name
        }

    @staticmethod
    def make_thread_resume(thread):
        """
        Return a message with information about the thread that resumed its
        execution.
        """
        return {
            'type': 'THREAD_RESUME',
            'id': thread.id,
            'name': thread.name
        }

    @staticmethod
    def make_thread_pause(thread):
        """
        Return a message with information about the thread being paused and
        the position at which it stopped.
        """
        frame = thread.current_frame
        f_path = frame.f_code.co_filename
        f_line = frame.f_lineno

        return {
            'type': 'THREAD_PAUSE',
            'id': thread.id,
            'file': f_path,
            'line':f_line,
        }

    @staticmethod
    def make_thread_stop(thread):
        """
        Return a message with information about the thread that is ending its
        execution.
        """
        return {
            'type': 'THREAD_STOP',
            'id': thread.id,
        }

    @staticmethod
    def make_debug_start():
        """Create the message that indicates that the debug session ended."""
        return {
            'type': 'DEBUG_START'
        }

    @staticmethod
    def make_debug_end():
        """Create the message that indicates that the debug session ended."""
        return {
            'type': 'DEBUG_END'
        }
