#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This module contains the ThreadsView related objects. A ThreadsView is a
QWidget that shows several threads in a tree format with their stacktrace.

This ThreadView, uses a BasicProviders.TreeContentProvider and a
BasicProviders.LabelProvider for the representation of the ThreadsView's
model.
"""

from PyQt4.QtCore import SIGNAL
from PyQt4.QtCore import pyqtSignal
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QWidget
from PyQt4.QtGui import QIcon
from PyQt4.QtGui import QTreeWidget
from PyQt4.QtGui import QHeaderView
from PyQt4.QtGui import QTreeWidgetItem
from PyQt4.QtGui import QTreeWidgetItemIterator
from PyQt4.QtGui import QStandardItemModel
from PyQt4.QtGui import QPushButton
from PyQt4.QtGui import QVBoxLayout
from PyQt4.QtGui import QHBoxLayout
from PyQt4.QtGui import QLabel

import debugger_plugin.gui.BaseTreeViews


class ThreadsView(debugger_plugin.gui.BaseTreeViews.BaseTreeView):
    """
    Represents a a container for the current running threads
    """

    def __init__(self):
        debugger_plugin.gui.BaseTreeViews.BaseTreeView.__init__(self)

        self._root = None
        self._childs = {}

        self.header().setHidden(True)
        self.header().setResizeMode(0, QHeaderView.ResizeToContents)
        self.header().setStretchLastSection(False)

        self.setSelectionMode(QTreeWidget.SingleSelection)
        self.setAnimated(True)

        self.rootIsDecorated = False
        self.uniformRowHeights = True
        self.allColumnsShowFocus = True
