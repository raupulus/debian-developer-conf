#!/usr/bin/env python
# -*- coding: utf-8 *-*
import tempfile
import os
import unittest

import process


class TestCodeExecutor(unittest.TestCase):

    code_a_eq_3 = '#/usr/env/python\na = 3'

    def test_load_file(self):
        # Write a small temporary script
        osfd, tp = tempfile.mkstemp()
        try:
            with os.fdopen(osfd, 'w') as fd:
                fd.write(self.code_a_eq_3)

            ce = process.CodeExecutor(filename=tp)
            self.assertEquals(ce._code.rstrip(), self.code_a_eq_3)
        finally:
            os.remove(tp)

    def test_run_with_file(self):
        # Write a small temporary script
        osfd, tp = tempfile.mkstemp()
        try:
            with os.fdopen(osfd, 'w') as fd:
                fd.write(self.code_a_eq_3)

            global_run = {'a': 2}
            ce = process.CodeExecutor(filename=tp)
            ce.run(global_run)
            self.assertEquals(global_run['a'], 3)
        finally:
            os.remove(tp)

    def test_load_string(self):
        ce = process.CodeExecutor(string=self.code_a_eq_3)
        self.assertEquals(ce._code.rstrip(), self.code_a_eq_3)

    def test_run_with_string(self):
        global_run = {'a': 2}
        ce = process.CodeExecutor(string=self.code_a_eq_3)
        ce.run(global_run)
        self.assertEquals(global_run['a'], 3)


if __name__ == '__main__':
    unittest.main()
