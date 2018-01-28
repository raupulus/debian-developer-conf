#!/usr/bin/env python
# -*- coding: utf-8 -*-
import unittest
import os

import breakpoints

class BreakpointManagerTest(unittest.TestCase):

    def test_add(self):
        #
        f = './file.txt'
        fabs = os.path.abspath(f)
        l = 89
        l2 = 91
        bmgr = breakpoints.BreakpointManager()

        bmgr.add(f, l)
        bmgr.add(f, l2)

        self.assertTrue(bmgr.check(f, l))

    def test_check(self):
        #
        f = './file.txt'
        fabs = os.path.abspath(f)
        l = 89
        l2 = 91
        bmgr = breakpoints.BreakpointManager()

        bmgr.add(f, l)
        bmgr.add(f, l2)

        self.assertTrue(bmgr.check(f, l))
        self.assertTrue(bmgr.check(f, l2))

    def test_remove_file(self, filename = None):
        #
        f = './file.txt'
        l = 89
        f2 = './file2.txt'
        l2 = 92
        bmgr = breakpoints.BreakpointManager()

        bmgr.add(f, l)
        bmgr.add(f2, l2)
        bmgr.remove(f)

        self.assertFalse(bmgr.check(f, l))
        self.assertTrue(bmgr.check(f2, l2))

    def test_remove_all(self, filename = None):
        #
        f = './file.txt'
        l = 89
        f2 = './file2.txt'
        l2 = 92
        bmgr = breakpoints.BreakpointManager()

        bmgr.add(f, l)
        bmgr.add(f2, l2)

        bmgr.remove()

        self.assertFalse(bmgr.check(f, l))
        self.assertFalse(bmgr.check(f2, l2))


if __name__ == '__main__':
    unittest.main()
