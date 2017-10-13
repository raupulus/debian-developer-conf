#!/usr/bin/env python
# -*- coding: utf-8 -*-
""" """
import debugger_plugin.core.models
import unittest


class TestWatchModel(unittest.TestCase):

    def test_str(self):
        e_name = "a"
        e_type = "int"
        e_val = "1"
        wmodel = debugger_plugin.core.models.WatchModel(e_name, e_type, e_val)

        res = str(wmodel)

        self.assertTrue(res.find(e_name) != -1)
        self.assertTrue(res.find(e_type) != -1)
        self.assertTrue(res.find(e_val) != -1)


class TestThreadGroup(unittest.TestCase):

    #def test_get(self) also
    def test_add(self):
        tgroup = debugger_plugin.core.models.ThreadGroup('name')
        tobj = debugger_plugin.core.models.ThreadModel(1, 'thread')
        tgroup.add(1, tobj)
        tobj2 = tgroup.get(1)
        self.assertEquals(tobj, tobj2)

    def test_add_replace(self):
        tgroup = debugger_plugin.core.models.ThreadGroup('name')
        tobj = debugger_plugin.core.models.ThreadModel(1, 'thread')
        tobj2 = debugger_plugin.core.models.ThreadModel(1, 'thread2')
        tgroup.add(1, tobj)
        tgroup.add(1, tobj2)
        tobj3 = tgroup.get(1)
        self.assertEquals(tobj2, tobj3)

    def test_remove_existing(self):
        tgroup = debugger_plugin.core.models.ThreadGroup('name')
        tobj = debugger_plugin.core.models.ThreadModel(1, 'thread')
        tgroup.add(1, tobj)
        tgroup.remove(1)
        self.assertRaises(KeyError, tgroup.get, 1)

    def test_remove_notexisting(self):
        tgroup = debugger_plugin.core.models.ThreadGroup('name')
        self.assertRaises(KeyError, tgroup.remove, 1)

    def test_iter(self):
        tgroup = debugger_plugin.core.models.ThreadGroup('name')
        tobj1 = debugger_plugin.core.models.ThreadModel(1, 'thread')
        tobj2 = debugger_plugin.core.models.ThreadModel(2, 'thread')
        tgroup.add(1, tobj1)
        tgroup.add(2, tobj2)
        input_list = [tobj1, tobj2]
        res_list = list(tgroup)
        self.assertEquals(input_list, res_list)


class TestThreadModel(unittest.TestCase):
    """
    """
    RUNNING = 10
    PAUSED = 20
    STOPPED = 30

    def test_str(self):
        tid = "123"
        tname = "nombre"
        tmodel = debugger_plugin.core.models.ThreadModel(tid, tname)
        res = str(tmodel)
        self.assertTrue(res.find(tid) != -1)
        self.assertTrue(res.find(tname) != -1)


class TestThreadStackEntry(unittest.TestCase):
    """ """

    def test_str(self):
        child = debugger_plugin.core.models.ThreadStackEntry("c.py", 2)
        parent = debugger_plugin.core.models.ThreadStackEntry("p.py", 1, child)
        res = str(parent)
        self.assertTrue(res.find("p.py") != -1)
        self.assertTrue(res.find("1") != -1)
        self.assertEquals(parent.child, child)

if __name__ == '__main__':
    unittest.main()
