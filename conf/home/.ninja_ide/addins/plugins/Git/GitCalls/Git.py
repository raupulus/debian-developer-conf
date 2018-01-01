# -*- coding: utf-8 *-*
import re
from git import Repo
from git import InvalidGitRepositoryError


class Git():

    def __init__(self):
        self.staged = {"M": set(), "A": set(), "D": set()}
        self.no_staged = {"M": set(), "?": set(), "D": set()}
        self.files_text = {}

    def init(self, path):
        try:
            Repo.create(path)
            message = "Success"
        except IOError:
            message = "Problem writing folder"
        return message

    def check_git(self, path):
        call_status = True
        try:
            repo = Repo(path)
            repo.git.status()
        except InvalidGitRepositoryError:
            call_status = False
        return call_status

    def status(self, path):
        repo = Repo(path)
        call = repo.git.status("--porcelain")
        pattern = re.compile("(.)([^ ])?  ?(.*)")
        data = pattern.findall(call)
        for changes in data:
            if changes[0] == ' ':
                self.no_staged[changes[1]].add(changes[2])
            elif changes[0] == '?':
                self.no_staged[changes[0]].add(changes[2])
            elif changes[1] == '':
                self.staged[changes[0]].add(changes[2])
            else:
                self.staged[changes[0]].add(changes[2])
                self.no_staged[changes[1]].add(changes[2])

    def text(self, path, a_file, state=False, file_text=False):
        file_text = unicode(file_text).splitlines()
        source = ""
        source_info = {}
        repo = Repo(path)
        n = 0
        if state:
            call = repo.git.diff(state, a_file)
        else:
            call = repo.git.diff(a_file)
        text = False
        for line in call.splitlines():
            if line.startswith("@"):
                text = True
                pattern = r"@@ .(\d+),(\d+) .(\d+),(\d+) @@"
                s = re.compile(pattern)
                pos = s.search(line).groups()
                current = int(pos[2]) - 1
                continue
            if text == True:
                if line.startswith('+'):
                    source_info[current] = '+'
                    source += line[1:]
                    file_text[current] = line[1:]
                elif line.startswith('-'):
                    source_info[current] = '-'
                    source += line[1:]
                    file_text.insert(current, line[1:])
                else:
                    source_info[current] = '='
                    source += line[1:]
                    file_text[current] = line[1:]
                source += "\n"
                n += 1
                current += 1
        final = ""
        for t in file_text:
            final += t.decode("utf-8") + "\n"
        return (source, source_info, final)

    def add(self, path, a_file):
        repo = Repo(path)
        repo.git.add(a_file)

    def unstage(self, path, a_file):
        repo = Repo(path)
        repo.git.checkout("--", a_file)

    def commit(self, path, a_file, msg):
        repo = Repo(path)
        repo.git.commit(a_file, "-m", msg)

    def uncommit(self, path, a_file):
        repo = Repo(path)
        repo.git.reset("HEAD", a_file)

    def branch(self, path):
        repo = Repo(path)
        call = repo.git.branch()
        branches = []

        for x in call.splitlines():
            if x.startswith("*"):
                branches.insert(0, x[2:])
            else:
                branches.append(x[2:])

        return branches

    def change_branch(self, path, branch):
        repo = Repo(path)
        repo.git.checkout(branch)

    def add_branch(self, path, branch):
        repo = Repo(path)
        repo.git.branch(branch)

    def delete_branch(self, path, branch):
        repo = Repo(path)
        if branch != "master":
            try:
                repo.git.branch("-d", branch)
            except:
                return "Branch ''{0}'' not fully merged".format(branch)

    def merge_branches(self, path, branch):
        repo = Repo(path)
        try:
            repo.git.merge(branch)
        except:
            return "Cant merge branches"

    def force_delete_branch(self, path, branch):
        repo = Repo(path)
        if branch != "master":
            repo.git.branch("-D", branch)
