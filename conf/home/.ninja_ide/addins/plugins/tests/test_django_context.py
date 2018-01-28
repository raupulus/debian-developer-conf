# -*- coding: utf-8 *-*
from __future__ import absolute_import
import unittest

from gui import DjangoContext
sample_context_list = ["foo", "foo.bar", "baz", "baz.0"]


class TestDjangoContext(unittest.TestCase):
    def test_process_context_list(self):
        a_context = DjangoContext(sample_context_list)
        a_model = a_context._model
        self.assertIn("foo", a_model)
        self.assertIn("bar", a_model['foo'].children)
        self.assertIn("baz", a_model)
        self.assertIn("0", a_model['baz'].children)

    def test_serialize_context_list(self):
        a_context = DjangoContext(sample_context_list)
        a_context_list = a_context._serialize_context_list()
        for each_path in sample_context_list:
            self.assertIn(each_path, a_context_list)


if __name__ == "__main__":
    unittest.main()
