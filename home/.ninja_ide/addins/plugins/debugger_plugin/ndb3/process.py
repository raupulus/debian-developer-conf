#!/usr/bin/env python
# -*- coding: utf-8 *-*
"""
The process module contains the functions to execute code from either a
string or a file.
"""
import sys

def runsource(source, glob=None, loc=None, filename="<string>"):
        """Run the source code using glob as globals and loc as locals."""
        _code = source

        # Define basic globals if they were not specified
        if glob is None:
            import __builtin__
            glob = {
                '__name__': '__main__',
                '__builtins__': __builtin__,
            }

        # If not locals were specified, use globals
        if loc is None:
            loc = glob

        # Compile and execute code
        c_code = compile(source=_code, filename=filename, mode='exec')
        exec c_code in glob, loc

def runfile(filename, glob=None, loc=None):
        """Run the code in filename using glob as globals and loc as locals."""
        _code = "pass"
        # Load source code from file
        with open(filename, 'r') as fp:
            _code = fp.read() + "\n"

        runsource(_code, glob, loc, filename=filename)


if __name__ == "__main__":
    print repr(sys.argv)
    if not sys.argv[1:]:
        print "File name is missing"
        raise SystemExit

    # Run code
    runfile(sys.argv[1])
