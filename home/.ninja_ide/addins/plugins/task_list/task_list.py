# -*- coding: utf-8 -*-

import os
import re

from ninja_ide.core import plugin
from PyQt4.QtCore import SIGNAL

from PyQt4.QtGui import QIcon
from PyQt4.QtGui import QAbstractItemView
from PyQt4.QtGui import QHeaderView
from PyQt4.QtGui import QTreeWidget
from PyQt4.QtGui import QTreeWidgetItem


class TaskList(plugin.Plugin):
    def initialize(self):
        #get the services!
        self.main_s = self.locator.get_service('editor')
        self.explorer_s = self.locator.get_service('explorer')

        #explorer
        self._task_widget = TaskWidget(self.locator)
        self.explorer_s.add_tab(self._task_widget, "Tasks")


class TaskWidget(QTreeWidget):

    TASK_IMAGE = os.path.join(os.path.dirname(__file__), 'task.png')
    TODO_REG = re.compile("#(\\s)*TODO(\\s)*\\:(\\s)*.")
    FIXME_REG = re.compile("#(\\s)*FIXME(\\s)*\\:(\\s)*.")
    OPTIMIZE_REG = re.compile("#(\\s)*OPTIMIZE(\\s)*\\:(\\s)*.")

    def __init__(self, locator):
        QTreeWidget.__init__(self)
        self.locator = locator
        self._explorer_s = self.locator.get_service('explorer')
        self._main_s = self.locator.get_service('editor')
        #on current tab changed refresh
        self._main_s.currentTabChanged.connect(self._on_tab_changed)
        #on file saved refresh
        self._main_s.fileSaved.connect(self._on_file_saved)

        self.header().setHidden(True)
        self.setSelectionMode(self.SingleSelection)
        self.setAnimated(True)
        self.header().setHorizontalScrollMode(QAbstractItemView.ScrollPerPixel)
        self.header().setResizeMode(0, QHeaderView.ResizeToContents)
        self.header().setStretchLastSection(False)

        self.connect(self, SIGNAL("itemClicked(QTreeWidgetItem *, int)"),
            self._go_to_definition)

    def _on_tab_changed(self):
        self.refresh_tasks()

    def _on_file_saved(self, fileName):
        self.refresh_tasks()

    def refresh_tasks(self):
        editorWidget = self._main_s.get_editor()
        if editorWidget:
            source = self._main_s.get_text()
            self._parse_tasks(source)

    def _go_to_definition(self, item):
        #the root doesn't go to anywhere
        if item.parent() is not None:
            self._main_s.jump_to_line(item.lineno)

    def _parse_tasks(self, source_code):
        self.clear()
        #create roots
        todo_root = QTreeWidgetItem(self, ['TODO'])
        fixme_root = QTreeWidgetItem(self, ['FIXME'])
        optimize_root = QTreeWidgetItem(self, ['OPTIMIZE'])

        lines = source_code.split("\n")
        lineno = 0
        for line in lines:
            #apply the regular expressions
            todo_match = self.TODO_REG.search(line)
            fixme_match = self.FIXME_REG.search(line)
            optimize_match = self.OPTIMIZE_REG.search(line)
            if todo_match:
                content = line[todo_match.end() - 1:]
                item = TaskItem(todo_root, [content], lineno)
                item.setIcon(0, QIcon(self.TASK_IMAGE))
            elif fixme_match:
                content = line[fixme_match.end() - 1:]
                item = TaskItem(fixme_root, [content], lineno)
                item.setIcon(0, QIcon(self.TASK_IMAGE))
            elif optimize_match:
                content = line[optimize_match.end() - 1:]
                item = TaskItem(optimize_root, [content], lineno)
                item.setIcon(0, QIcon(self.TASK_IMAGE))

            lineno += 1
        self.expandAll()


class TaskItem(QTreeWidgetItem):

    def __init__(self, parent, content, lineno):
        QTreeWidgetItem.__init__(self, parent, content)
        self.lineno = lineno
