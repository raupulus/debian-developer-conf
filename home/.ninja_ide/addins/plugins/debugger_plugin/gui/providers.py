#!/usr/bin/env python
# -*- coding: utf-8 -*-
""" """

import debugger_plugin.gui.resources
import debugger_plugin.core.models
import debugger_plugin.gui.BaseProviders

class WatchesContentProvider(debugger_plugin.gui.BaseProviders.TreeContentProvider):

    def __init__(self):
        pass

    def getChildren(self, parent):
        """Returns the child elements of the given element."""
        result = []
        if isinstance(parent, list):
            return parent
        if isinstance(parent, debugger_plugin.core.models.WatchModel):
            result = parent.children
        return result

    def getParent(self, element):
        """
        Returns the parent of the given element. Returns None if the element
        has no parent element.
        """
        return None

    def hasChildren(self, element):
        """Returns whether the given element has children."""
        if isinstance(element, debugger_plugin.core.models.WatchModel) and len(element.children) > 0:
            return True
        return False


class WatchesExprLabelProvider(debugger_plugin.gui.BaseProviders.LabelProvider):
    """
    A ThreadsLabelProvider object maps a given element of the tree's model to
    a label (text with image) that is used to display the Threads and their
    status.
    """

    def __init__(self):
        """Creates a new ThreadsLabelProvider."""
        pass

    def getText(self, obj):
        """Returns the image for the given element."""
        if isinstance(obj, list):
            return "<Watches>"
        return obj.expression

    def getImage(self, obj):
        """Returns the text for the given element."""
        if isinstance(obj, debugger_plugin.core.models.WatchModel):
            return debugger_plugin.gui.resources.RES_ICON_WATCH_ITEM
        return None


class WatchesValueLabelProvider(debugger_plugin.gui.BaseProviders.LabelProvider):
    """
    A ThreadsLabelProvider object maps a given element of the tree's model to
    a label (text with image) that is used to display the Threads and their
    status.
    """

    def __init__(self):
        """Creates a new ThreadsLabelProvider."""
        pass

    def getText(self, obj):
        """Returns the image for the given element."""
        if isinstance(obj, list):
            return ""
        return "({0}) {1}".format(obj.type, obj.value)

    def getImage(self, obj):
        """Returns the text for the given element."""
        return None


class ThreadsContentProvider(debugger_plugin.gui.BaseProviders.TreeContentProvider):
    """
    A ThreadsContentProvider provides elements to the TreeViewer from the
    TreeViewer's model. The ThreadsContentProvider adapts the model to the
    ui control.
    """

    def __init__(self):
        """Creates a new ThreadsContentProvider."""
        pass

    def getChildren(self, parent):
        """Returns the child elements of the given element."""
        result = []
        if isinstance(parent, debugger_plugin.core.models.ThreadGroup):
            return list(parent)
        return result

    def getParent(self, element):
        """
        Returns the parent of the given element. Returns None if the element
        has no parent element.
        """
        return None

    def hasChildren(self, element):
        """Returns whether the given element has children."""
        if isinstance(element, debugger_plugin.core.models.ThreadGroup):
            return True
        return False


class ThreadsLabelProvider(debugger_plugin.gui.BaseProviders.LabelProvider):
    """
    A ThreadsLabelProvider object maps a given element of the tree's model to
    a label (text with image) that is used to display the Threads and their
    status.
    """

    def __init__(self):
        """Creates a new ThreadsLabelProvider."""
        pass

    def getImage(self, obj):
        """Returns the text for the given element."""
        if isinstance(obj, debugger_plugin.core.models.ThreadGroup):
            return debugger_plugin.gui.resources.RES_ICON_THREAD_GROUP

        icon = debugger_plugin.gui.resources.RES_ICON_THREAD_ITEM_RUN
        if obj.state == debugger_plugin.core.models.ThreadModel.PAUSED:
            icon = debugger_plugin.gui.resources.RES_ICON_THREAD_ITEM_PAUSE
        return icon

