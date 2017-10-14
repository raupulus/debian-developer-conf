# -*- coding: utf-8 -*-
# PEP8:OK, LINT:OK, PY3:OK


#############################################################################
## This file may be used under the terms of the GNU General Public
## License version 2.0 or 3.0 as published by the Free Software Foundation
## and appearing in the file LICENSE.GPL included in the packaging of
## this file.  Please review the following information to ensure GNU
## General Public Licensing requirements will be met:
## http:#www.fsf.org/licensing/licenses/info/GPLv2.html and
## http:#www.gnu.org/copyleft/gpl.html.
##
## This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
## WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#############################################################################


# metadata
" Base64 Encoder "
__version__ = ' 1.8 '
__license__ = ' GPL '
__author__ = ' juancarlospaco '
__email__ = ' juancarlospaco@ubuntu.com '
__url__ = ''
__date__ = ' 12/12/2013 '
__prj__ = ' base64 '
__docformat__ = 'html'
__source__ = ''
__full_licence__ = ''


# imports
from base64 import b64encode, urlsafe_b64encode
from datetime import datetime
from getpass import getuser
from mimetypes import guess_type
from os import path, sep

from PyQt4.QtCore import QDir, Qt
from PyQt4.QtGui import (QApplication, QCheckBox, QColor, QComboBox, QCompleter,
                         QCursor, QDirModel, QDockWidget, QFileDialog,
                         QGraphicsDropShadowEffect, QIcon, QInputDialog, QLabel,
                         QLineEdit, QMenu, QMessageBox, QPushButton, QAction,
                         QScrollArea, QSizePolicy, QVBoxLayout, QWidget)
from sip import setapi

from ninja_ide.core import plugin
from ninja_ide.gui.explorer.explorer_container import ExplorerContainer

try:
    from PyKDE4.kdeui import KTextEdit as QTextEdit
except ImportError:
    from PyQt4.QtGui import QTextEdit  # lint:ok


# API 2
(setapi(a, 2) for a in ("QDate", "QDateTime", "QString", "QTime", "QUrl",
                        "QTextStream", "QVariant"))


# constans
PY_EMBED = '''#!/usr/bin/env python
# -*- coding: utf-8 -*-


# imports
from base64 import decodestring
from cStringIO import StringIO


#metadata
__author__ = ' {} '
__date__ = ' {} '


embedded_file = StringIO(decodestring({}))
print(embedded_file.read())
'''


###############################################################################


class Main(plugin.Plugin):
    " Main Class "
    def initialize(self, *args, **kwargs):
        " Init Main Class "
        super(Main, self).initialize(*args, **kwargs)
        self.infile = QLineEdit(path.expanduser("~"))
        self.infile.setPlaceholderText(' /full/path/to/file ')
        self.infile.returnPressed.connect(self.run)
        self.completer, self.dirs = QCompleter(self), QDirModel(self)
        self.dirs.setFilter(QDir.AllEntries | QDir.NoDotAndDotDot)
        self.completer.setModel(self.dirs)
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        self.completer.setCompletionMode(QCompleter.PopupCompletion)
        self.infile.setCompleter(self.completer)

        self.menu = QMenu('Base64')
        self.menu.aboutToShow.connect(self.build_submenu)
        self.ex_locator = self.locator.get_service('explorer')
        self.ex_locator.add_project_menu(self.menu, lang='all')

        self.open = QPushButton(QIcon.fromTheme("folder-open"), 'Open')
        self.open.setCursor(QCursor(Qt.PointingHandCursor))
        self.open.clicked.connect(lambda: self.infile.setText(str(
            QFileDialog.getOpenFileName(self.dock, "Open a File to Encode...",
            path.expanduser("~"), ';;'.join(['{}(*.{})'.format(e.upper(), e)
            for e in ['*', 'jpg', 'png', 'webp', 'svg', 'gif', 'webm']])))))
        self.chckbx1 = QCheckBox('Use basic Caesar Cipher (ROT13)')
        self.chckbx1.setToolTip('Use "string".decode("rot13") to Decipher ! ')
        self.chckbx2 = QCheckBox('Use "data:type/subtype;base64,..."')
        self.chckbx2.setChecked(True)
        self.chckbx3 = QCheckBox('Copy encoded output to Clipboard')
        self.chckbx4 = QCheckBox('Use URL-Safe Base64 Encoder')
        self.combo1 = QComboBox()
        self.combo1.addItems(['Do Not Generate Code', 'Generate CSS embed Code',
            'Generate Python Embed Code', 'Generate HTML embed Code',
            'Generate JS embed Code', 'Generate QML embed Code'])
        self.combo1.currentIndexChanged.connect(self.combo_changed)

        self.output = QTextEdit('''
        We can only see a short distance ahead,
        but we can see plenty there that needs to be done.
        - Alan Turing ''')
        self.output.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)

        self.button = QPushButton(QIcon.fromTheme("face-cool"), 'Encode BASE64')
        self.button.setCursor(QCursor(Qt.PointingHandCursor))
        self.button.setMinimumSize(100, 50)
        self.button.clicked.connect(self.run)
        glow = QGraphicsDropShadowEffect(self)
        glow.setOffset(0)
        glow.setBlurRadius(99)
        glow.setColor(QColor(99, 255, 255))
        self.button.setGraphicsEffect(glow)
        glow.setEnabled(True)

        class TransientWidget(QWidget):
            ' persistant widget thingy '
            def __init__(self, widget_list):
                ' init sub class '
                super(TransientWidget, self).__init__()
                vbox = QVBoxLayout(self)
                for each_widget in widget_list:
                    vbox.addWidget(each_widget)

        tw = TransientWidget((QLabel('<i>Encode file as plain text string</i>'),
            QLabel('<b>File to Encode:'), self.infile, self.open, self.chckbx2,
            self.chckbx3, self.chckbx1, self.chckbx4,
            QLabel('<b>Embedding Template Code:'), self.combo1,
            QLabel(' <b>Base64 String Output: '), self.output,
            QLabel('<center><small><i>' + ''.join((__doc__, __version__,
                   __license__, 'by', __author__))), self.button
        ))
        self.scrollable, self.dock = QScrollArea(), QDockWidget()
        self.scrollable.setWidgetResizable(True)
        self.scrollable.setWidget(tw)
        self.dock.setWindowTitle(__doc__)
        self.dock.setStyleSheet('QDockWidget::title{text-align: center;}')
        self.dock.setWidget(self.scrollable)
        ExplorerContainer().addTab(self.dock, "Base64")
        self.guimode = QComboBox(self.dock)
        self.guimode.addItems(['Full Mode', 'Simple Mode'])
        self.guimode.currentIndexChanged.connect(self.guimode_change)

    def guimode_change(self):
        """ Change from Simple Mode to Full Mode by Hide or Show Widgets """
        if self.guimode.currentIndex() is 0:
            self.chckbx1.show()
            self.chckbx2.show()
            self.chckbx3.show()
            self.chckbx4.show()
        else:
            self.chckbx1.hide()
            self.chckbx2.hide()
            self.chckbx3.hide()
            self.chckbx4.hide()
            self.chckbx1.setChecked(False)
            self.chckbx2.setChecked(True)
            self.chckbx3.setChecked(False)
            self.chckbx4.setChecked(False)

    def build_submenu(self):
        ''' build sub menu on the fly based on file path '''
        self.menu.clear()
        if self.ex_locator.get_current_project_item().isFolder is not True:
            filenam = self.ex_locator.get_current_project_item().get_full_path()
            self.menu.addActions([
                QAction('Copy {} as Base64'.format(path.basename(filenam)[:50]),
                        self, triggered=lambda:
                        QApplication.clipboard().setText(
                        '"data:{};charset=utf-8;base64,{}"'.format(
                            guess_type(filenam, strict=False)[0],
                            b64encode(open(filenam, "rb").read())))),
                QAction('Copy {} as Base64 URL-Safe'.format(
                        path.basename(filenam)[:50]),
                        self, triggered=lambda:
                        QApplication.clipboard().setText(
                        '"data:{};charset=utf-8;base64,{}"'.format(
                            guess_type(filenam, strict=False)[0],
                            urlsafe_b64encode(open(filenam, "rb").read()))))])
            self.menu.show()

    def run(self):
        ' run the encoding '
        mimetype = guess_type(str(self.infile.text()).strip(), strict=False)[0]
        _mime = mimetype if mimetype is not None else self.ask_mime()
        fle = str(self.infile.text()).strip().replace('file:///', '/')
        encoder = urlsafe_b64encode if self.chckbx4.isChecked() else b64encode
        if int(path.getsize(fle)) / 1024 / 1024 >= 1:
            QMessageBox.information(self.dock, __doc__,
            '''<b style="color:red"> WARNING!: File size is > 1 Megabyte!,<br>
            this will take some time, depending your CPU Processing power!.''')
        output = '"{}{}{}{}"'.format(
            'data:' if self.chckbx2.isChecked() is True else '',
            _mime if self.chckbx2.isChecked() is True else '',
           ';charset=utf-8;base64,' if self.chckbx2.isChecked() is True else '',
            encoder(open(fle, "rb").read()))
        if self.combo1.currentIndex() is 1:
            output = ('html, body { margin:0; padding:0; background: url(' +
            output + ') no-repeat center center fixed; background-size:cover }')
        elif self.combo1.currentIndex() is 2:
            output = PY_EMBED.format(getuser(),
                     datetime.now().isoformat().split('.')[0], output)
        elif self.combo1.currentIndex() is 3:
            output = '<img src={} alt="{}" title="{}"/>'.format(output,
                     fle.split(sep)[-1], fle.split(sep)[-1])
        elif self.combo1.currentIndex() is 4:
            output = 'var embedded_file = window.atob({}); '.format(output)
        elif self.combo1.currentIndex() is 5:
            output = 'Image { source: ' + output + ' } '
        if self.chckbx1.isChecked() is True:
            output = str(output).encode('rot13')
        if self.chckbx3.isChecked() is True:
            QApplication.clipboard().setText(output)
        self.output.setPlainText(output)
        self.output.setFocus()
        self.output.selectAll()

    def ask_mime(self):
        ' ask user for mime type '
        return str(QInputDialog.getText(self.dock, __doc__, 'Write a MIME-Type',
               QLineEdit.Normal, 'application/octet-stream')[0]).strip().lower()

    def combo_changed(self):
        ' on combo changed '
        if self.combo1.currentIndex() is 1 or self.combo1.currentIndex() is 3:
            self.chckbx1.setChecked(False)
            self.chckbx2.setChecked(True)
        elif self.combo1.currentIndex() is 2 or self.combo1.currentIndex() is 4:
            self.chckbx1.setChecked(False)
            self.chckbx2.setChecked(False)


###############################################################################


if __name__ == "__main__":
    print(__doc__)
