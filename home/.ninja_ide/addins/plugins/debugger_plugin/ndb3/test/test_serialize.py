#!/usr/bin/env python
# -*- coding: utf-8 *-*
import unittest

import serialize


class TestSerialization(unittest.TestCase):

    def test_serialize_basic(self):
        res = serialize.serialize('i', 'i', 1)
        self.assertEquals(res['name'], 'i')
        self.assertFalse(res['has_childs'])

    def test_serialize_flat_dict(self):
        f_dict = {'a': 'First','b': 'Second','c': 'Third'}
        res = serialize.serialize('f', 'f', f_dict)

        self.assertEquals(res['name'], 'f')
        self.assertTrue(res['has_childs'])
        self.assertEquals(res['type'], 'dict')
        self.assertEquals(len(res['childs']), 3)

        # Check the first child
        f_child = res['childs'][0]
        self.assertEquals(f_child['type'], 'str')

    def test_serialize_deep_dict(self):
        d_dict = { 'a': [1, 2, 3], 'b': [4, 5, 6], 'c': [7, 8, 9]}
        res = serialize.serialize('d', 'd', d_dict, 2)

        self.assertEquals(res['name'], 'd')
        self.assertTrue(res['has_childs'])
        self.assertEquals(len(res['childs']), 3)

        # Check the first child
        f_child = res['childs'][0]
        self.assertTrue(f_child['has_childs'])
        self.assertEquals(f_child['type'], 'list')
        self.assertEquals(len(f_child['childs']), 3)

    def test_serialize_object(self):
        class _TestObject(object):
            """Class object to test serialization of object types."""
            def __init__(self):
                """Testing method."""
                self._attr = "a"
            def un_metodo(self, unarg = None):
                """Testing method."""
                return "Hola" + self._attr + repr(unarg)
            def otro_metodo(self):
                """Testing method."""
                return "Chau" + self._attr

        c_obj = _TestObject()
        res = serialize.serialize('c', 'c', c_obj)

        self.assertEquals(res['name'], 'c')
        self.assertTrue(res['has_childs'])
        self.assertEquals(res['type'], '_TestObject')
        # Check the first child
        f_child = res['childs'][0]
        self.assertEquals(f_child['type'], 'instancemethod')


if __name__ == '__main__':
    unittest.main()
