#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os

class BreakpointManager(object):

    def __init__(self):
        self.breakpoints = {}

    def add(self, filename, linenumber):
        """Add a breaking point in the specified filename and line number."""
        fullpath = os.path.abspath(filename)
        lines = self.breakpoints.setdefault(fullpath, [])
        if not linenumber in lines:
            lines.append(linenumber)

    def check(self, filename, linenumber):
        """
        Check wheather the filename:linenumber is a break point. Return True if
        it is, False otherwise.
        """
        fullpath = os.path.abspath(filename)
        if fullpath in self.breakpoints:
            breaklines = self.breakpoints.get(fullpath, [])
            return linenumber in breaklines
        return False

    def remove(self, filename = None):
        """
        Clear the registry of breakpoints for a specified file, if not
        specified, clear all breakpoints.
        """
        if filename:
            filename = os.path.abspath(filename)
            try:
                del self.breakpoints[filename]
            except:
                # Ignore if filename wasn't there in the first place
                pass
        else:
            self.breakpoints = {}
