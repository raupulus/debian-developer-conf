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
" NINJA-IDE Diff and Patch "
__version__ = ' 0.1 '
__license__ = ' GPL '
__author__ = ' juancarlospaco '
__email__ = ' juancarlospaco@ubuntu.com '
__url__ = ''
__date__ = ' 25/04/2013 '
__prj__ = ' diff '
__docformat__ = 'html'
__source__ = ''
__full_licence__ = ''


# imports
from os import path

from PyQt4.QtGui import QIcon
from PyQt4.QtGui import QLabel
from PyQt4.QtGui import QDockWidget
from PyQt4.QtGui import QToolBar
from PyQt4.QtGui import QAction
from PyQt4.QtGui import QFileDialog
from PyQt4.QtGui import QMessageBox

from PyQt4.QtCore import QUrl

try:
    from PyKDE4.kdecore import *
    from PyKDE4.kparts import *
except ImportError:
    pass

from ninja_ide.core import plugin

from .diffgui import DiffGUI as Diff_GUI


###############################################################################


class Main(plugin.Plugin):
    " dock Class "
    def initialize(self):
        " Init Class dock "
        self.dock = QDockWidget()
        self.dock.setFeatures(QDockWidget.DockWidgetFloatable |
                                           QDockWidget.DockWidgetMovable)
        self.dock.setWindowTitle(__doc__)
        self.dock.setStyleSheet('QDockWidget::title{text-align: center;}')
        self.open = QAction(QIcon.fromTheme("document-open"), 'Open DIFF', self)
        self.diff = QAction(QIcon.fromTheme("document-new"), 'Make DIFF', self)
        self.diff.triggered.connect(self.run_gui_and_get_results)
        self.save = QAction(QIcon.fromTheme("document-save"), 'Save DIFF', self)
        self.save.triggered.connect(self.save_a_diff)
        self.patc = QAction(QIcon.fromTheme("document-edit"), 'PATCH it!', self)
        self.patc.triggered.connect(lambda: QMessageBox.information(self.dock,
            __doc__, ' Sorry. This Feature is not ready yet !, thank you... '))
        QToolBar(self.dock).addActions((self.open, self.diff,
                                        self.save, self.patc))
        try:
            self.factory = KPluginLoader("komparepart").factory()
            self.part = self.factory.create(self)
            self.dock.setWidget(self.part.widget())
            self.open.triggered.connect(lambda: self.part.openUrl(KUrl(str(
                QFileDialog.getOpenFileName(self.dock, ' Open a DIFF file ',
                                        path.expanduser("~"), ';;(*.diff)')))))
        except:
            self.dock.setWidget(QLabel(""" <center>
            <h3>ಠ_ಠ<br> ERROR: Please, install Kompare App ! </h3><br>
            <br><i> (Sorry, cant embed non-Qt Apps). </i><center>"""))

        self.misc = self.locator.get_service('misc')
        self.misc.add_widget(self.dock,
                                QIcon.fromTheme("edit-select-all"), __doc__)

    def run_gui_and_get_results(self):
        ' run_gui_and_get_results '
        gui = Diff_GUI()
        if gui.diff_path is not None and path.isfile(gui.diff_path) is True:
            self.part.openUrl(KUrl(str(gui.diff_path)))
        return run_gui.diff_path

    def save_a_diff(self):
        ' save a diff '
        out_file = path.abspath(str(QFileDialog.getSaveFileName(self.dock,
                   'Save a Diff file', path.expanduser("~"), ';;(*.diff)')))
        inp_file = file(str(QUrl(
               self.part.url()).toString()).replace('file://', ''), 'r').read()
        end_file = file(out_file, 'w')
        end_file.write(inp_file)
        end_file.close()


###############################################################################


if __name__ == "__main__":
    print(__doc__)
