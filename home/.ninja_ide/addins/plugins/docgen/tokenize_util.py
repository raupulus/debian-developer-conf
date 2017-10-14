# -*- coding: utf-8 -*-
import tokenize
from io import StringIO

def token_def(text, keywords=('def', 'class')):
    '''
    Tokenizes given string and looks for keywords in the first line.
    Returns the keyword and the index of the end of the definition.
    '''
    tokens = tokenize.generate_tokens(StringIO(text).readline)
    def_type = ''

    for t_type, t_string, t_start, t_end, t_line in tokens:
        if t_type == tokenize.NAME:
            if t_string in keywords:
                def_type = t_string
                break
        elif t_type == tokenize.NL: # no def or class keyword found in current line
            # check if newline is directly at beginning
            return def_type, 0 if t_end == (1, 1) else -1

    counter = 0 # keep record of total characters, needed for newlines
    probably_end = False # end of def is '):'. only ':' is not enough
    for t_type, t_string, t_start, t_end, t_line in tokens:
        if t_type == tokenize.OP:
            if t_string == ')':
                probably_end = True
                continue
            elif probably_end and t_string == ':': # really is end of definition
                return def_type, counter + t_end[1]
        elif t_type == tokenize.NL:
            if probably_end: probably_end = False
            counter += t_end[1]
    #TODO: find check for 'def f(a,\n\n <other code>'

def token_args(text):
    'Tokenizes given string and returns every name inside two parantheses.'
    tokens = tokenize.generate_tokens(StringIO(text).readline)

    # go to start of arguments
    for t_type, t_string, t_start, t_end, t_line in tokens:
        if t_type == tokenize.OP and t_string == '(':
            break
        elif t_type == tokenize.NL:
            return

    skip_arg = False # for skipping values of keyword args
    in_seq = False   # when skipping, don't mistake ',' in a seq as a signal for next arg
    parenthesis = [] # keep track of opening (, [ and {
    open_parenthesis = {')': '(', ']': '[', '}': '{'}
    args = []
    # parse args and return every argument's name
    for t_type, t_string, t_start, t_end, t_line in tokens:
        if skip_arg:
            if t_type == tokenize.OP:
                if t_string in ('(', '[', '{'):
                    in_seq = True # we're now in a sequence - ignore ','
                    parenthesis.append(t_string)
                elif in_seq and t_string in (')', ']', '}'):
                    # closing parenthesis - remove it
                    parenthesis.remove(open_parenthesis[t_string])
                    if len(parenthesis) == 0:
                        in_seq = False # not in a sequence definition anymore
                elif not in_seq and t_string == ',':
                    skip_arg = False # stop skipping, next arg coming
            continue
        elif t_type == tokenize.NAME:
            args.append(t_string)
        elif t_type == tokenize.OP:
            if t_string == '=': # next token is the value of a keyword arg
                skip_arg = True
    return args
