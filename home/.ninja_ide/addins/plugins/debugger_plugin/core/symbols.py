#!/usr/bin/env python
# -*- coding: utf-8 *-*
"""
    Module to handle symbols.
"""
import ast
import sys


class SymbolFinder(ast.NodeVisitor):
    """
    Utility class that helps find a particular symbol by position (line and
    column).
    """

    def __init__(self, source):
        """
        Initializes the SymbolFinder and parses the filename for symbols.
        """
        self.symbols = dict()
        self.source = source

    def parse(self):
        """ """
        module = ast.parse(self.source)
        self.visit(module)

    def __add_node(self, node):
        """
        Callback method executed by the ProcessorNodeVisitor when a symbol
        is found in the source. This method adds the symbol to the cache for
        latter retrieval.
        """
        self.symbols.setdefault(node.line, []).append(node)

    def get(self, line, column):
        """
        Gets the symbol at the position given by line and column in the current
        file.

        If two symbols overlap, e.g. "os.path" is both "os" and "os.path", in
        this case, will return os, since os.path is bigger.
        """
        if line not in self.symbols:
            return None

        slen = sys.maxint
        sym = None
        for s in self.symbols[line]:
            if column >= s.column and column < (s.column + s.size) and s.size < slen:
                sym = s
        return sym

    def generic_visit(self, node):
        """Method overwritted from the NodeVisitor class."""
        if type(node) in [ast.Name, ast.ClassDef, ast.FunctionDef, ast.Attribute]:
            # Add node offset for special cases
            if isinstance(node, ast.ClassDef):
                node.col_offset += len("class ")
            if isinstance(node, ast.FunctionDef):
                node.col_offset += len("def ")

            self.__add_node(SymbolNode(node=node,
                                       line=node.lineno,
                                       column=node.col_offset))
        ast.NodeVisitor.generic_visit(self, node)


class SymbolNode:
    """
    This class represents an object symbol. A symbol is a variable or attribute
    of a class. Given a source file, a symbol is located at a certain line
    and column.
    """

    def __init__(self, expr=None, node=None, line=0, column=0):
        """
        Initializes a SymbolNode. The SymbolNode can be created either by
        specifying the expression (str) or by passing the node with the ast.
        """
        self.expression = expr or self._calculate_expression(node)
        self.size = len(self.expression)
        self.line = line
        self.column = column

    def _calculate_expression(self, node):
        """Return the textual representation of a node."""
        sep = ""
        if not node:
            return ""

        if isinstance(node, ast.FunctionDef) or isinstance(node, ast.ClassDef):
            return node.name

        if isinstance(node, ast.Attribute):
            sep = "."

        res = str(node)
        if hasattr(node, '_fields'):
            res = []
            for i in node._fields:
                rn = self._calculate_expression(getattr(node, i))
                if rn:
                    if i == 's':
                        rn = '"' + rn + '"'
                    if i == "func":
                        rn = rn + "()"
                    res.append(rn)
            res = sep.join(res)
        return res

    def __repr__(self):
        """
        Returns the string representation of this SymbolNode
        """
        return "SymbolNode(expr={0}, line={1}, column={2})".format(
                    repr(self.expression), repr(self.line), repr(self.column))


if __name__ == "__main__":

    if not sys.argv[1:]:
        print "File name is missing"
        raise SystemExit

    # Test SymbolFinder
    sym_finder = SymbolFinder(open(sys.argv[1]).read())
    sym_finder.parse()

    import pprint
    pprint.pprint(sym_finder.symbols)

    print sym_finder.get(22, 5)
