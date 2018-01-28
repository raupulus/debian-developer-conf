#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This module provides basic tree views.
"""
from PyQt4.QtGui import QTreeWidget
from PyQt4.QtGui import QTreeWidgetItem
from PyQt4.QtGui import QIcon


class BaseTreeViewItem(QTreeWidgetItem):
    """
    Base TreeViewItem used by the BaseTreeView to show objects in the model.
    """

    def __init__(self, parent):
        """Constructor."""
        QTreeWidgetItem.__init__(self, parent)
        self.data = None


class BaseTreeView(QTreeWidget):
    """
    Base class for all TreeView objects that uses a ContentProvider and a
    LabelProvider for its content.
    """

    def __init__(self, hide_parent_element = False):
        """Constructor."""
        QTreeWidget.__init__(self)
        self._content_provider = None
        self._label_providers = {}
        # index table to lookup treeview items associated with model objects.
        self.__indextable = []
        self._hide_parent = hide_parent_element

    def setContentProvider(self, provider):
        """Set the ContentProvider that will feed model items to this view."""
        self._content_provider = provider

    def setLabelProvider(self, provider, column = 0):
        """
        Set the LabelProvider that will be used to specify the values to
        show in a specified column.
        """
        if column < self.columnCount():
            self._label_providers[column] = provider

    def setInput(self, input):
        """Set the input object for this view."""
        self._input = input
        self.update()

    def __newItem(self, parent, data):
        """
        Return a new item to insert in the tree.
        Each derived class should override this method to return the proper
        TreeViewItem.
        """
        item = BaseTreeViewItem(parent)
        item.data = data
        self.__indextable.append(item)
        return item

    def __addItem(self, parent_item, data, expanded = False):
        """
        Add a new item to the tree with under the specifed parent. Also add
        all children of data.
        """
        item = self.findObjectsItem(data)
        if not item:
            item = self.__newItem(parent_item, data)

        # Update its content
        self.update(data)

        # Expand item
        self.setItemExpanded(item, expanded)

        return item

    def __removeItem(self, item):
        """Remove the treeviewitem and all of its children from the tree."""
        parent = item.parent()
        if parent:
            root = parent.removeChild(item)
        else:
            root = self.invisibleRootItem()
            root.removeChild(item)
        self.__indextable.remove(item)

    def __updateItem(self, item, data):
        """Update the treeviewitem with the data from the data model."""
        # Set text for item
        for column in xrange(self.columnCount()):
            name = str(data)
            item.setIcon(column, QIcon())

            if column in self._label_providers:
                name = self._label_providers[column].getText(data)
                icon = self._label_providers[column].getImage(data)
                if icon:
                    item.setIcon(column, QIcon(icon))
            item.setText(column, name)

        # Remove old data associated with this item
        if item.data != data:
            # remove old data
            del item.data
            item.data = data

    def findObjectsItem(self, data):
        """Return the BaseTreeViewItem that represents the data."""
        for item in self.__indextable:
            if item.data == data:
                return item
        return None

    def update(self, data = None, expand = False):
        """
        Update the specified element in the tree, including the number of
        children. This method, unlike refresh, deals with structural changes.
        """
        if data is None or data == self._input:
            # Remove the top parent
            data = self._input
            item = self.invisibleRootItem()
        else:
            item = self.findObjectsItem(data)
            self.__updateItem(item, data)

        children = self._content_provider.getChildren(data)

        # Remove old ones
        currents = item.takeChildren()
        for child in currents:
            if not child.data in children:
                # Remove child since its not in the new children set
                item.removeChild(child)
            else:
                # Re-added since we took al children.
                item.addChild(child)

        # Add the rest of the children (__addItem won't add those that are
        # already added).
        for child in children:
            self.__addItem(item, child, expand)
