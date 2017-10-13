# -*- coding: utf-8 *-*
import os
from GitCalls import Git as git

from ninja_ide.core import plugin

from PyQt4.QtCore import Qt
from PyQt4.QtCore import SIGNAL

from PyQt4.QtGui import QIcon
from PyQt4.QtGui import QColor
from PyQt4.QtGui import QLabel
from PyQt4.QtGui import QAction
from PyQt4.QtGui import QDialog
from PyQt4.QtGui import QCheckBox
from PyQt4.QtGui import QTextEdit
from PyQt4.QtGui import QTextFormat
from PyQt4.QtGui import QTextCursor
from PyQt4.QtGui import QPushButton
from PyQt4.QtGui import QHBoxLayout
from PyQt4.QtGui import QMessageBox
from PyQt4.QtGui import QGridLayout
from PyQt4.QtGui import QListWidget
from PyQt4.QtGui import QInputDialog
from PyQt4.QtGui import QListWidgetItem


class GitStatus(QDialog):

    def __init__(self, plugin, git, path):
        QDialog.__init__(self)
        self.git = git
        self.plugin = plugin
        self.setWindowTitle('Git status')

        layout = QGridLayout(self)

        branches = self.git.branch(unicode(path))

        self.s_branches = QListWidget()

        if len(branches) > 0:
            self.s_branches.addItems(branches[1:])
            self.actual_branch = QLabel("<h2>{0}</h2>".format(branches[0]))
        else:
            self.actual_branch = QLabel()

        branch = QLabel("<h2>Branches</h2>")
        change_branch = QPushButton("Change to")
        merge_branches = QPushButton("Merge branch")

        H = QHBoxLayout()
        delete_branch = QPushButton("Delete branch")
        add_branch = QPushButton("Add branch")
        H.addWidget(add_branch)
        H.addWidget(delete_branch)

        self.lists = []

        no_staged = QLabel("<h2>No staged</h2>")

        untracked_files = QLabel("Untracked files")
        self.untracked_files = QListWidget()
        self.lists.append(self.untracked_files)

        modified_files = QLabel("Modified files")
        self.modified_files = QListWidget()
        self.lists.append(self.modified_files)

        deleted_files = QLabel("Deleted files")
        self.deleted_files = QListWidget()
        self.lists.append(self.deleted_files)

        staged = QLabel("<h2>Staged</h2>")

        added_files = QLabel("Added files")
        self.added_files = QListWidget()
        self.lists.append(self.added_files)

        s_modified_files = QLabel("Modified files")
        self.s_modified_files = QListWidget()
        self.lists.append(self.s_modified_files)

        s_deleted_files = QLabel("Deleted files")
        self.s_deleted_files = QListWidget()
        self.lists.append(self.s_deleted_files)

        layout.addWidget(self.actual_branch, 0, 0, Qt.AlignHCenter)
        layout.addWidget(change_branch, 1, 0)
        layout.addWidget(merge_branches, 2, 0)
        layout.addWidget(no_staged, 3, 0)
        layout.addWidget(untracked_files, 4, 0)
        layout.addWidget(self.untracked_files, 5, 0)
        layout.addWidget(modified_files, 6, 0)
        layout.addWidget(self.modified_files, 7, 0)
        layout.addWidget(deleted_files, 8, 0)
        layout.addWidget(self.deleted_files, 9, 0)

        layout.addWidget(branch, 0, 1)
        layout.addWidget(self.s_branches, 1, 1)
        layout.addLayout(H, 2, 1)
        layout.addWidget(staged, 3, 1)
        layout.addWidget(added_files, 4, 1)
        layout.addWidget(self.added_files, 5, 1)
        layout.addWidget(s_modified_files, 6, 1)
        layout.addWidget(self.s_modified_files, 7, 1)
        layout.addWidget(s_deleted_files, 8, 1)
        layout.addWidget(self.s_deleted_files, 9, 1)

        self.fill(self.git.no_staged["?"], self.untracked_files)
        self.fill(self.git.no_staged["M"], self.modified_files)
        self.fill(self.git.no_staged["D"], self.deleted_files)

        self.fill(self.git.staged["A"], self.added_files)
        self.fill(self.git.staged["M"], self.s_modified_files)
        self.fill(self.git.staged["D"], self.s_deleted_files)

        self.staged_b = QPushButton('Stage files', self)
        self.unstage_b = QPushButton("Unstage files", self)
        self.commit_b = QPushButton('Commit files', self)
        self.uncommit_b = QPushButton("Uncommit files", self)

        layout.addWidget(self.staged_b, 10, 0)
        layout.addWidget(self.unstage_b, 11, 0)
        layout.addWidget(self.commit_b, 10, 1)
        layout.addWidget(self.uncommit_b, 11, 1)

        self.setLayout(layout)

        self.connect(self.staged_b, SIGNAL('clicked()'), self.add)
        self.connect(self.unstage_b, SIGNAL('clicked()'), self.unstage)
        self.connect(self.commit_b, SIGNAL('clicked()'), self.commit)
        self.connect(self.uncommit_b, SIGNAL('clicked()'), self.uncommit)
        self.connect(change_branch, SIGNAL("clicked()"), self.change_branch)
        self.connect(add_branch, SIGNAL("clicked()"), self.add_branch)
        self.connect(delete_branch, SIGNAL("clicked()"), self.delete_branch)
        self.connect(merge_branches, SIGNAL("clicked()"), self.merge_branches)

    def fill(self, a_list, widget_list):
        for x in a_list:

            item = QListWidgetItem()
            widget_list.addItem(item)
            check_box = QCheckBox(x)
            widget_list.setItemWidget(item, check_box)

    def add(self):
        path = self.plugin.editor.get_project_owner()
        for pos in reversed(xrange(self.untracked_files.count())):

            item = self.untracked_files.item(pos)
            widget = self.untracked_files.itemWidget(item)
            text = widget.text()

            if widget.isChecked():
                self.git.add(path, text)
                self.untracked_files.removeItemWidget(item)
                self.untracked_files.takeItem(pos)
                item = QListWidgetItem()
                self.added_files.addItem(item)
                check_box = QCheckBox(text)
                self.added_files.setItemWidget(item, check_box)

        for pos in reversed(xrange(self.modified_files.count())):

            item = self.modified_files.item(pos)
            widget = self.modified_files.itemWidget(item)
            text = widget.text()

            if widget.isChecked():
                self.git.add(path, widget.text())
                self.modified_files.removeItemWidget(item)
                self.modified_files.takeItem(pos)
                item = QListWidgetItem()
                self.s_modified_files.addItem(item)
                check_box = QCheckBox(text)
                self.s_modified_files.setItemWidget(item, check_box)

        for pos in reversed(xrange(self.deleted_files.count())):

            item = self.deleted_files.item(pos)
            widget = self.deleted_files.itemWidget(item)
            text = widget.text()

            if widget.isChecked():
                self.git.add(path, widget.text())
                self.deleted_files.removeItemWidget(item)
                self.deleted_files.takeItem(pos)
                item = QListWidgetItem()
                self.s_deleted_files.addItem(item)
                check_box = QCheckBox(text)
                self.s_deleted_files.setItemWidget(item, check_box)

    def unstage(self):

        path = self.plugin.editor.get_project_owner()
        for pos in reversed(xrange(self.untracked_files.count())):

            item = self.untracked_files.item(pos)
            widget = self.untracked_files.itemWidget(item)

            if widget.isChecked():
                self.git.unstage(path, widget.text())
                self.untracked_files.removeItemWidget(item)
                self.untracked_files.takeItem(pos)

        for pos in reversed(xrange(self.modified_files.count())):

            item = self.modified_files.item(pos)
            widget = self.modified_files.itemWidget(item)

            if widget.isChecked():
                self.git.unstage(path, widget.text())
                self.modified_files.removeItemWidget(item)
                self.modified_files.takeItem(pos)

        for pos in reversed(xrange(self.deleted_files.count())):

            item = self.deleted_files.item(pos)
            widget = self.deleted_files.itemWidget(item)

            if widget.isChecked():
                self.git.unstage(path, widget.text())
                self.deleted_files.removeItemWidget(item)
                self.deleted_files.takeItem(pos)

    def commit(self):

        msg = QInputDialog.getText(self, "Commit message", "Commit Message:")

        if msg[1] == False:
            return(0)

        path = self.plugin.editor.get_project_owner()
        for pos in reversed(xrange(self.added_files.count())):

            item = self.added_files.item(pos)
            widget = self.added_files.itemWidget(item)

            if widget.isChecked():
                self.git.commit(path, str(widget.text()), msg[0])
                self.added_files.removeItemWidget(item)
                self.added_files.takeItem(pos)

        for pos in reversed(xrange(self.s_modified_files.count())):

            item = self.s_modified_files.item(pos)
            widget = self.s_modified_files.itemWidget(item)

            if widget.isChecked():
                self.git.commit(path, widget.text(), msg[0])
                self.s_modified_files.removeItemWidget(item)
                self.s_modified_files.takeItem(pos)

        for pos in reversed(xrange(self.s_deleted_files.count())):

            item = self.s_deleted_files.item(pos)
            widget = self.s_deleted_files.itemWidget(item)

            if widget.isChecked():
                self.git.commit(path, widget.text(), msg[0])
                self.s_deleted_files.takeItem(pos)
                self.s_deleted_files.removeItemWidget(item)

    def uncommit(self):
        path = self.plugin.editor.get_project_owner()
        for pos in reversed(xrange(self.added_files.count())):

            item = self.added_files.item(pos)
            widget = self.added_files.itemWidget(item)
            text = widget.text()

            if widget.isChecked():
                self.git.uncommit(path, str(widget.text()))
                self.added_files.removeItemWidget(item)
                self.added_files.takeItem(pos)
                item = QListWidgetItem()
                self.untracked_files.addItem(item)
                check_box = QCheckBox(text)
                self.untracked_files.setItemWidget(item, check_box)

        for pos in reversed(xrange(self.s_modified_files.count())):

            item = self.s_modified_files.item(pos)
            widget = self.s_modified_files.itemWidget(item)
            text = widget.text()

            if widget.isChecked():
                self.git.uncommit(path, widget.text())
                self.s_modified_files.removeItemWidget(item)
                self.s_modified_files.takeItem(pos)
                item = QListWidgetItem()
                self.modified_files.addItem(item)
                check_box = QCheckBox(text)
                self.modified_files.setItemWidget(item, check_box)

        for pos in reversed(xrange(self.s_deleted_files.count())):

            item = self.s_deleted_files.item(pos)
            widget = self.s_deleted_files.itemWidget(item)
            text = widget.text()

            if widget.isChecked():
                self.git.uncommit(path, widget.text())
                self.s_deleted_files.removeItemWidget(item)
                self.s_deleted_files.takeItem(pos)
                item = QListWidgetItem()
                self.deleted_files.addItem(item)
                check_box = QCheckBox(text)
                self.deleted_files.setItemWidget(item, check_box)

    def change_branch(self):

        path = self.plugin.editor.get_project_owner()

        item = self.s_branches.currentItem()

        if item and not self.something():
            text = item.text()
            self.git.change_branch(path, text)
            self.s_branches.clear()
            self.s_branches.addItems(self.git.branch(unicode(path))[1:])
            self.actual_branch.setText("<h2>{0}<h2>".format(text))
        if self.something():
            v = QMessageBox()
            v.setText("Error: you have unsaved changes")
            v.setIcon(v.Warning)
            v.exec_()

    def add_branch(self):

        path = self.plugin.editor.get_project_owner()

        msg = QInputDialog.getText(self, "New branch", "Branch Name:")

        if msg[1] == False:
            return(0)

        self.git.add_branch(path, msg[0])
        self.s_branches.clear()
        self.s_branches.addItems(self.git.branch(unicode(path))[1:])

    def delete_branch(self):
        path = self.plugin.editor.get_project_owner()
        item = self.s_branches.currentItem()
        if item:
            text = str(item.text())
            call = self.git.delete_branch(path, text)

            if not call:
                self.s_branches.clear()
                self.s_branches.addItems(self.git.branch(unicode(path))[1:])

            else:
                m = QMessageBox()
                m.setText("<h2>" + call + "</h2>")
                m.setInformativeText("Force deletion?")
                m.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
                m.setDefaultButton(QMessageBox.Cancel)
                c = m.exec_()
                if c == QMessageBox.Ok:

                    self.git.force_delete_branch(path, text)
                    self.s_branches.clear()

                    self.s_branches.addItems(self.git.branch(unicode(path))[1:])

    def merge_branches(self):
        path = self.plugin.editor.get_project_owner()
        item = self.s_branches.currentItem()
        if item:
            text = str(item.text())
            call = self.git.merge_branches(path, text)
            if call:
                m = QMessageBox()
                m.setText(call)
                m.setInformativeText("Unknown")
                m.setIcon(m.Critical)
                m.exec_()

    def something(self):
        for x in self.lists:
            if x.count() > 0:
                return True
        return False


class Git(plugin.Plugin):


    def initialize(self):

        self.editor = self.locator.get_service('editor')
        self.toolbar = self.locator.get_service('toolbar')
        self.menu = self.locator.get_service('menuApp')
        self.explorer = self.locator.get_service('explorer')

        self.plug_path = os.path.abspath(__file__)
        self.plug_path = os.path.dirname(self.path)

        git_status = QAction(QIcon(self.plug_path + '/Git/IMG/logo.png'),
                                'GIT status', self)
        git_unstage = QAction(QIcon(self.plug_path + '/Git/IMG/stage.png'),
                                'Show unstaged changes', self)
        git_stage = QAction(QIcon(self.plug_path + '/Git/IMG/commit.png'),
                                'Show staged Changes', self)
        self.toolbar.add_action(git_status)
        self.toolbar.add_action(git_unstage)
        self.toolbar.add_action(git_stage)

        self.connect(git_status, SIGNAL('triggered()'), self.check_git)

        self.connect(git_unstage,
                    SIGNAL('triggered()'), self.text_call)

        self.connect(git_stage,
                    SIGNAL('triggered()'),
                    lambda: self.text_call("--staged"))

        self.explorer.projectOpened.connect(self.check_project)
        self.proyectos = []
        self.tree = self.explorer.get_tree_projects()
        self.git = git.Git()
        self.text = {}

    def finish(self):
        pass

    def get_preferences_widget(self):
        pass

    def check_project(self, path):
        x = 0
        while self.tree.topLevelItem(x):
            item = self.tree.topLevelItem(x)
            if path == item.path and self.git.check_git(unicode(path)) == True:
                item.setIcon(0, QIcon(self.plug_path + '/Git/IMG/g.png'))

            x += 1

    def check_git(self):

        path = self.editor.get_project_owner()
        check = self.git.check_git(unicode(path))

        if check == True:
            self.status()  # status
            #solas
            #mas
            #dol

        else:
            msgBox = QMessageBox()
            msgBox.setText("<h2>Git not enabled</h2>")
            msgBox.setInformativeText("Do you want to enable it?")
            msgBox.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
            msgBox.setDefaultButton(QMessageBox.Cancel)
            if msgBox.exec_() == QMessageBox.Ok:
                self.init()

    def init(self):

        path = self.editor.get_project_owner()
        check = self.git.init(unicode(path))

        x = 0
        while self.tree.topLevelItem(x):
            item = self.tree.topLevelItem(x)
            if path == item.path:
                item.setIcon(0, QIcon(self.plug_path + '/Git/IMG/g.png'))
                break
            x += 1

        msgBox = QMessageBox()
        msgBox.setText("Git added to project")
        msgBox.setInformativeText(check)
        msgBox.exec_()

    def status(self):

        self.git = git.Git()
        path = self.editor.get_project_owner()
        self.git.status(unicode(path))

        info = GitStatus(self, self.git, path)
        info.exec_()

    def text_call(self, state=False):
        self.git = git.Git()
        path = self.editor.get_project_owner()
        a_file = self.editor.get_editor_path()
        text_file = self.editor.get_editor().get_text()

        if state:
            self.editor.add_editor('staged({0})'.format(os.path.basename(
                                                                    a_file)))

        else:
            self.editor.add_editor('unstaged({0})'.format(
                                                    os.path.basename(a_file)))

        editor = self.editor.get_editor()
        self.text[editor] = self.git.text(path, a_file, state, text_file)
        editor.insertPlainText(self.text[editor][2])

        self.connect(editor, SIGNAL("cursorPositionChanged()"), self.highlight)

        text = self.text[editor]

        for line in text[1]:

            if text[1][line] == "=":
                continue

            selection = QTextEdit.ExtraSelection()

            block = editor.document().findBlockByLineNumber(line)
            selection.cursor = editor.textCursor()
            selection.cursor.setPosition(block.position())
            if text[1][line] == "-":
                lineColor = QColor(255, 0, 0, 50)
            if text[1][line] == "+":
                lineColor = QColor(0, 0, 255, 50)
            selection.format.setBackground(lineColor)
            selection.format.setProperty(QTextFormat.FullWidthSelection, True)

            selection.cursor.movePosition(QTextCursor.EndOfBlock)
            editor.extraSelections.append(selection)

        editor.setExtraSelections(editor.extraSelections)
        editor.setReadOnly(True)
        editor.textModified = False

    def highlight(self):

        editor = self.editor.get_editor()
        text = self.text[editor]
        for line in text[1]:
            if text[1][line] == "=":
                continue

            selection = QTextEdit.ExtraSelection()

            block = editor.document().findBlockByLineNumber(line)
            selection.cursor = editor.textCursor()
            selection.cursor.setPosition(block.position())
            if text[1][line] == "-":
                lineColor = QColor(255, 0, 0, 50)
            if text[1][line] == "+":
                lineColor = QColor(0, 0, 255, 50)
            selection.format.setBackground(lineColor)
            selection.format.setProperty(QTextFormat.FullWidthSelection, True)

            selection.cursor.movePosition(QTextCursor.EndOfBlock)
            editor.extraSelections.append(selection)

        editor.setExtraSelections(editor.extraSelections)
        editor.setReadOnly(True)
