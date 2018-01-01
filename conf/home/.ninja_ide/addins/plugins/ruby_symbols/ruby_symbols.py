# -*- coding: utf-8 *-*

import re

from ninja_ide.core import plugin
from ninja_ide.core import plugin_interfaces


EXTENSION = 'rb'


class RubySymbols(plugin.Plugin):

    def initialize(self):
        self.explorer_s = self.locator.get_service('explorer')
        # Set a project handler for NINJA-IDE Plugin
        self.explorer_s.set_symbols_handler(EXTENSION,
            RubySymbolsHandler())


class RubySymbolsHandler(plugin_interfaces.ISymbolsHandler):

    def __init__(self):
        class_ = r'^(\s)*class(\s)+(\w)+.*'
        function_ = r'^(\s)*def(\s)+((\w)+(\.)*)+(\s)*(\(.)*'
        self.patClass = re.compile(class_)
        self.patFunction = re.compile(function_)
        self.patIndent = re.compile('^\s+')

    def obtain_symbols(self, source):
        """Returns a dict with the ruby symbols for sources."""
        source = source.split('\n')
        symbols = {}
        classes = {}
        functions = {}
        last_class = ''
        clazz_indent = 0
        for nro, line in enumerate(source):
            space = self.patIndent.match(line)
            if space is not None:
                indent = len(space.group())
            else:
                indent = 0

            if self.patClass.match(line):
                clazzname = line.split()[1]
                classes[clazzname] = (nro + 1, {'functions': {}})
                last_class = clazzname
                clazz_indent = indent
            elif self.patFunction.match(line):
                funcname = line.split()[1].split('(')[0]
                if indent > clazz_indent and last_class != '':
                    class_data = classes[last_class][1]
                    class_data['functions'][funcname] = nro + 1
                else:
                    last_class = ''
                    clazz_indent = 0
                    functions[funcname] = nro + 1
        if classes:
            symbols['classes'] = classes
        if functions:
            symbols['functions'] = functions
        return symbols
