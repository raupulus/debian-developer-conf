#!/usr/bin/env python
# -*- coding: utf-8 *-*
"""
    Module to serialize objects.
"""
__all__ = ['serialize']

__PLAIN_TYPES__ = [ bool, buffer, file, float, int, long,
                type(None), object, slice, str, type, ]


def serialize(name, expr, result, depth = 1):
    """
    Serialize the result of the expression as a nested array of name, expr and
    value items. Depth argument defines how deep the serialization should go.

    Example:

    >>> deep_dict = {'uno': [1, 11, 111], 'dos': [2, 22, 222],}
    >>> serialize('somename', "deep_dict", deep_dict)
    {
        'name': 'somename',
        'expr': 'deep_dict',
        'type': 'dict',
        'value': "{'dos': [2, 22, 222], 'uno': [1, 11, 111]}",
        'has_childs': True,
        'childs': [{
            'has_childs': True,
            'expr': "(deep_dict)['dos']",
            'type': 'list',
            'name': 'dos',
            'value': '[2, 22, 222]'
        },{
            'has_childs': True,
            'expr': "(deep_dict)['uno']",
            'type': 'list',
            'name': 'uno',
            'value': '[1, 11, 111]'
        }],
    }
    (Output of serialize was beautified to show the structure of the result)
    """
    s_res = {}    # serialized result
    s_res['name'] = name
    s_res['expr'] = expr
    s_res['value'] = repr(result)

    result_type = type(result)
    s_res['type'] = result_type.__name__
    s_res['has_childs'] = False

    if not result_type in __PLAIN_TYPES__:
        # We've got a compound value
        s_res['has_childs'] = True

    if depth == 0 or not s_res['has_childs']:
        return s_res

    s_res['childs'] = []
    if isinstance(result, dict):
        for key, val in result.items():
            s_child = serialize(
                    key, "({0})[{1}]".format(expr, repr(key)),
                    val, depth -1)
            s_res['childs'].append(s_child)

    elif isinstance(result, list) or isinstance(result, tuple):
        for key, val in enumerate(result):
            s_child = serialize(
                    key, "({0})[{1}]".format(expr, repr(key)),
                    val, depth -1)
            s_res['childs'].append(s_child)
    else:
        attrs = dir(result)
        for attr in attrs:
            if attr.startswith('__') or attr.startswith('_'):
                continue
            try:
                val = getattr(result, attr)
                s_child = serialize(attr,
                                         "({0}).{1}".format(expr, attr),
                                         val,
                                         depth -1)
                s_res['childs'].append(s_child)
            except AttributeError as atte:
                print repr(atte)

    return s_res

