#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Module that contains objects to support watches
"""

from PyQt4.QtCore import SIGNAL
from PyQt4.QtCore import pyqtSignal
from PyQt4.QtCore import Qt
from PyQt4.QtGui import QAction
from PyQt4.QtGui import QWidget
from PyQt4.QtGui import QIcon
from PyQt4.QtGui import QTreeWidget
from PyQt4.QtGui import QTreeWidgetItem
from PyQt4.QtGui import QPushButton
from PyQt4.QtGui import QVBoxLayout
from PyQt4.QtGui import QHBoxLayout
from PyQt4.QtGui import QSpacerItem
from PyQt4.QtGui import QSizePolicy
from PyQt4.QtGui import QHeaderView

import debugger_plugin.gui.BaseTreeViews
import debugger_plugin.gui.providers
import debugger_plugin.gui.resources

import debugger_plugin.core.models


class WatchesView(debugger_plugin.gui.BaseTreeViews.BaseTreeView):
    """
    Widget that shows WatchItem.
    """
    #itemChanged = pyqtSignal(WatchItem, int, name="itemChanged(PyQt_PyObject, int)")

    def __init__(self):
        debugger_plugin.gui.BaseTreeViews.BaseTreeView.__init__(self)

        self.header().setHidden(False)
        self.header().setResizeMode(0, QHeaderView.ResizeToContents)
        self.header().setStretchLastSection(True)

        self.setSelectionMode(QTreeWidget.SingleSelection)
        self.setAnimated(True)

        self.rootIsDecorated = False
        self.uniformRowHeights = True
        self.allColumnsShowFocus = True

        self.setHeaderLabels(("Item", "Value"))


class WatchesWidget(QWidget):
    """
    Watches Widget.
    """
    itemChanged = pyqtSignal(object, name="itemChanged(PyQt_PyObject)")

    def __init__(self):
        QWidget.__init__(self)
        # Layout
        vbox = QVBoxLayout(self)
        # Model for Watches
        self.model = []
        # View for Watches
        self.view = WatchesView()
        self.view.setContentProvider(debugger_plugin.gui.providers.WatchesContentProvider())
        self.view.setLabelProvider(debugger_plugin.gui.providers.WatchesExprLabelProvider(), 0)
        self.view.setLabelProvider(debugger_plugin.gui.providers.WatchesValueLabelProvider(), 1)
        self.view.setInput(self.model)

        # Step over
        btn_add = QPushButton("Add Watch", self)
        self.connect(btn_add, SIGNAL("clicked()"), self.add_watch)

        vbox.setContentsMargins(0,0,0,0)
        vbox.addWidget(self.view)
        vbox.addSpacerItem(QSpacerItem(1, 0, QSizePolicy.Expanding))
        vbox.addWidget(btn_add)

        self.connect(self.view,
            SIGNAL("itemDoubleClicked(QTreeWidgetItem*, int)"),
                self.edit_item)
        self.connect(self.view,
            SIGNAL("itemChanged(QTreeWidgetItem*, int)"),
                self.__item_changed)

        # Expand top level item
        a = self.view.topLevelItem(0)
        self.view.expandItem(a)

    def __item_changed(self, item, column):
        """Emits the signal that receives from the QTreeWidget."""
        item_text = str(item.text(0))
        item_value = str(item.text(2))
        watch = item.data

        if not item_text:
            self.model.remove(watch)
            watch = self.model
        else:
            watch.expression = item_text
            watch.value = item_value
            self.itemChanged.emit(watch)

        try:
            self.view.blockSignals(True)
            self.view.update(watch)
        finally:
            self.view.blockSignals(False)

    def edit_item(self, item, column):
        '''
        Makes the GUI show to the user a field to modify either the expression
        (column = 1) or the value (column = 2). The appearance of the edit
        box depends on the OS and theme.
        '''
        data = item.data
        return True

    def get_model(self):
        return self.model

    def add_watch(self):
        try:
            self.view.blockSignals(True)
            f3 = debugger_plugin.core.models.WatchModel('<New watch>', '', '')
            self.model.append(f3)
            self.view.update(expand=True)

            # Get the corresponding item in the view and make it modify
            item = self.view.findObjectsItem(f3)
            # Make it editable
            item.setFlags(item.flags() | Qt.ItemIsEditable)
            self.view.editItem(item, 0)
        finally:
            self.view.blockSignals(False)
