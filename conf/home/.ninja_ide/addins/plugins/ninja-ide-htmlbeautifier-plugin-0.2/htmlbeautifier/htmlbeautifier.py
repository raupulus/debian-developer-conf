# -*- coding: UTF-8 -*-
# htmlbeautifier.py
#
# Copyright (C) ninja-ide.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
#  This plugins allows you to have your code pretty-printed
#   by pressing CTRL+SHIFT+P.
#  (It will not interfer with autopepper since there's files type validation)
#  It uses beautifulsoup4 and html.parser
#
# Initial development: Belug
#  Version: 0.2
#

# metadata
" HTMLBeautifier "
__version__ = ' 0.2 '
__license__ = ' GPL '
__author__ = ' Belug '
__email__ = ' belug@oss.cx" '
__url__ = ''
__date__ = ' 15/06/2013 '
__prj__ = ' htmlbeautifier '
__docformat__ = 'html'
__source__ = ''
__full_licence__ = ''


# imports
import os
import re

from bs4 import BeautifulSoup

#from PyQt4.QtGui import QAction, QIcon
#from PyQt4.QtCore import SIGNAL
from PyQt4 import QtCore

from ninja_ide.core import plugin
from ninja_ide.core import file_manager
from ninja_ide.core import settings

# Plugin definition


def inTagPrettify(str):
    result = re.sub(' {1,%d}' % settings.INDENT, ' ', str, flags=re.M)
    return result


def reformat_comments(matchobj):
    if re.search('\n', matchobj.group()):
        return inTagPrettify(matchobj.group())
    return matchobj.group()


class HTMLBeautifier(plugin.Plugin):

    def initialize(self):
        # Init your plugin
        self.editor_s = self.locator.get_service('editor')
        self.toolbar_s = self.locator.get_service('toolbar')

        self.plug_path = os.path.dirname(self.path)

        self.editor_s.editorKeyPressEvent.connect(self._handle_keypress)
        # self._add_menu()

    def finish(self):
        # Shutdown your plugin
        pass

    def get_preferences_widget(self):
        # Return a widget for customize your plugin
        pass

    def _handle_keypress(self, event):

        keyMod = event.modifiers()

        is_SHIFT = keyMod & QtCore.Qt.ShiftModifier
        is_CTRL = keyMod & QtCore.Qt.ControlModifier

        is_shortcut = (is_SHIFT and is_CTRL and event.key() == QtCore.Qt.Key_P)
        if is_shortcut:
            self._prettify()
        return

    def _prettify(self):
        exts = settings.SYNTAX.get('html')['extension']
        file_ext = file_manager.get_file_extension(
            self.editor_s.get_editor_path())

        if file_ext in exts:
            editorWidget = self.editor_s.get_editor()
            if editorWidget:
                last_cursor_pos = editorWidget.get_cursor_position()

                source = self.editor_s.get_text()
                code_soup = BeautifulSoup(source, "html.parser")
                pretty_code = code_soup.prettify(formatter=inTagPrettify)
                #Cleaning the forgotten comments of the parser
                pretty_code = re.sub(r'<!--(.*?)-->', reformat_comments, pretty_code, flags=re.S)
                #Indenting all the code
                pretty_code = re.sub(r'^( *)(.*)$', r'%s\2' %
                                     (r'\1' * settings.INDENT), pretty_code, flags=re.M)
                editorWidget.selectAll()
                editorWidget.textCursor().insertText(pretty_code)

                editorWidget.set_cursor_position(last_cursor_pos)

    def _add_menu(self):
        pass
        # No logo yet
        # Adding toolbar icon
        # prettify = QAction(QIcon(self.plug_path + '/htmlbeautifier/logo.png'),
                         #'Prettify it!', self)
        # self.toolbar_s.add_action(prettify)
        # self.connect(prettify, SIGNAL('triggered()'), self._prettify)
