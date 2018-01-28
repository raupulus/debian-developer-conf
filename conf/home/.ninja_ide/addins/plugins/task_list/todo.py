import sys
import re

#Reg expression for the plugin
TODO_REG = re.compile("#TODO:(\s).")
FIXME_REG = re.compile("#FIXME:(\s).")
OPTIMIZE_REG = re.compile("#OPTIMIZE:(\s).")


if __name__ == '__main__':
    if len(sys.argv) > 1:
        f = sys.argv[1]
        try:
            f = open(f)
        except IOError, reason:
            print reason
            sys.exit(0)

        d = {
                "TODO": [],
                "FIXME": [],
                "OPTIMIZE": []
        }
        print "Buscando comentarios..."
        print
        n = 1
        for line in f.readlines():
            todo_match = TODO_REG.search(line)
            fix_match = FIXME_REG.search(line)
            opti_match = OPTIMIZE_REG.search(line)
            if todo_match:
                d["TODO"].append((n, line[todo_match.end() - 1:]))
                print line[todo_match.end() - 1:]
            elif fix_match:
                d["FIXME"].append((n, line[fix_match.end() - 1:]))
            elif opti_match:
                d["OPTIMIZE"].append((n, line[opti_match.end() - 1:]))
            n += 1
        f.close()
        print "TODO(%s)" % len(d["TODO"])
        for t in d["TODO"]:
            print "    line: %s    text: %s" % (t[0], t[1].strip())
        print "FIXME(%s)" % len(d["FIXME"])
        for t in d["FIXME"]:
            print "    line: %s    text: %s" % (t[0], t[1].strip())
        print "OPTIMIZE(%s)" % len(d["OPTIMIZE"])
        for t in d["OPTIMIZE"]:
            print "    line: %s    text: %s" % (t[0], t[1].strip())
    else:
        print "You should provide a file"
        sys.exit(0)
