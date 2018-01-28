#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This module offers a set of providers to work with basic views.
"""

class TreeContentProvider:
    """
    A TreeContentProvider provides elements to the TreeViewer from the
    TreeViewer's model. The TreeContentProvider adapts the model to the
    ui control.

    This is an "abstract interface", all methods in this class raise an
    NotImplementedError.
    """

    def __init__(self):
        """Creates a new TreeContentProvider."""
        raise NotImplementedError('Abstract interface.')

    def getChildren(self, parent):
        """Returns the child elements of the given element."""
        raise NotImplementedError('Abstract interface.')

    def getParent(self, element):
        """
        Returns the parent of the given element. Returns None if the element
        has no parent element.
        """
        raise NotImplementedError('Abstract interface.')

    def hasChildren(self, element):
        """Returns whether the given element has children."""
        raise NotImplementedError('Abstract interface.')


class LabelProvider:
    """
    A LabelProvider object maps a given element of the viewer's model to
    a label (text with optional image) that is used to display the element in
    the UI control.

    This is a base implementation, this LabelProvider will return the string
    representation for the text and no image.
    """

    def __init__(self):
        """Creates a new LabelProvider."""
        pass

    def getText(self, obj):
        """
        Returns the image for the given element. Default implementation
        returns the string representation of the object.
        """
        return str(obj)

    def getImage(self, obj):
        """
        Returns the image for the given element. Default implementation
        returns no image.
        """
        return None

