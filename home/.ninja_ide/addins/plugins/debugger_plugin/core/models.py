#!/usr/bin/env python
# -*- coding: utf-8 -*-
""" """
import os

class WatchModel:
    """
    """

    def __init__(self, ename, etype, evalue):
        """
        """
        self.expression = ename
        self.type = etype
        self.value = evalue
        self.children = []

    def __str__(self):
        """
        """
        return "{} = ({}){}".format(self.expression, self.type, self.value)

    def __repr__(self):
        return "WatchModel({}, {}, {})".format(repr(self.expression), repr(self.type), repr(self.value))

class ThreadGroup:
    """
    """

    def __init__(self, name):
        """
        """
        self.name = name
        self._threads = {}

    def add(self, tid, tobject):
        """
        """
        self._threads[tid] = tobject

    def remove(self, tid):
        """
        """
        del self._threads[tid]

    def get(self, tid):
        return self._threads.get(tid)

    def __iter__(self):
        for i in self._threads:
            yield self._threads[i]

    def __str__(self):
        return self.name

    def __repr__(self):
        return "ThreadGroup({})".format(repr(self.name))


class ThreadModel:
    """
    """
    RUNNING = 10
    PAUSED = 20
    STOPPED = 30

    def __init__(self, tid, tname, tstatus = STOPPED):
        self.ident = tid
        self.name = tname
        self.state = tstatus
        self.epointer = None

    def __str__(self):
        state = "running"
        if self.state == self.PAUSED:
            state = str(self.epointer)
        elif self.state == self.STOPPED:
            state = "stopped"
        return "[{}] {} ({})".format(self.ident, self.name, state)

    def __repr__(self):
        return "ThreadModel({}, {}, {})".format(repr(self.ident), repr(self.name), repr(self.state))

class ThreadStackEntry:
    """ """

    def __init__(self, filename, linenumber):
        self.filename = filename
        self.linenumber = linenumber

    def __str__(self):
        return "{0}:{1}".format(os.path.basename(self.filename), self.linenumber)

    def __repr__(self):
        return "ThreadStackEntry({}, {})".format(repr(self.filename), repr(self.linenumber))
