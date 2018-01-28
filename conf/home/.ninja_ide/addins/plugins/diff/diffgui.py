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
from os import linesep
from tempfile import gettempdir
from datetime import datetime
from commands import getoutput
from subprocess import call

from PyQt4.QtGui import QIcon
from PyQt4.QtGui import QLabel
from PyQt4.QtGui import QFileDialog
from PyQt4.QtGui import QWidget
from PyQt4.QtGui import QVBoxLayout
from PyQt4.QtGui import QHBoxLayout
from PyQt4.QtGui import QComboBox
from PyQt4.QtGui import QCursor
from PyQt4.QtGui import QLineEdit
from PyQt4.QtGui import QCheckBox
from PyQt4.QtGui import QDialog
from PyQt4.QtGui import QPushButton
from PyQt4.QtGui import QGroupBox
from PyQt4.QtGui import QDialogButtonBox
from PyQt4.QtGui import QMessageBox
from PyQt4.QtGui import QApplication
from PyQt4.QtGui import QCompleter
from PyQt4.QtGui import QDirModel

from PyQt4.QtCore import Qt
from PyQt4.QtCore import QDir


###############################################################################


class DiffGUI(object):
    ' diff gui class '
    def __init__(self):
        ' make a diff method with GUI '
        self.dialog = QDialog()
        self.diff_path = None

        # directory auto completer
        self.completer = QCompleter(self.dialog)
        self.dirs = QDirModel(self.dialog)
        self.dirs.setFilter(QDir.AllEntries | QDir.NoDotAndDotDot)
        self.completer.setModel(self.dirs)
        self.completer.setCaseSensitivity(Qt.CaseInsensitive)
        self.completer.setCompletionMode(QCompleter.PopupCompletion)
        #self.completer.setCompletionMode(QCompleter.InlineCompletion)

        self.group1 = QGroupBox()
        self.group1.setTitle('Diff')
        self.frmt = QComboBox(self.group1)
        self.frmt.addItems(['Unified', 'Normal', 'Context'])
        self.file1 = QLineEdit()
        self.file1.setPlaceholderText('/full/path/to/one_file.py')
        self.file1.setCompleter(self.completer)
        self.file2 = QLineEdit()
        self.file2.setPlaceholderText('/full/path/to/another_file.py')
        self.file2.setCompleter(self.completer)
        self.fout = QLineEdit()
        self.fout.setText(''.join((path.join(gettempdir(),
                     datetime.now().strftime('%d-%b-%Y_%H:%M:%S.diff')))))
        self.fout.setPlaceholderText('/full/path/to/output_file.diff')
        self.fout.setCompleter(self.completer)
        self.regex = QLineEdit()
        self.regex.setPlaceholderText('DONT use unless you know what are doing')
        self.regex.setToolTip('Do NOT use unless you know what you are doing !')
        self.borig = QPushButton(QIcon.fromTheme("folder-open"), 'Open')
        self.borig.clicked.connect(lambda: self.file1.setText(str(
            QFileDialog.getOpenFileName(self.dialog, 'Open file to compare',
                                           path.expanduser("~"), ';;(*.*)'))))

        self.bmodi = QPushButton(QIcon.fromTheme("folder-open"), 'Open')
        self.bmodi.clicked.connect(lambda: self.file2.setText(str(
            QFileDialog.getOpenFileName(self.dialog, 'Open file to compare',
                                           path.expanduser("~"), ';;(*.*)'))))
        self.bout = QPushButton(QIcon.fromTheme("folder-open"), 'Open')
        self.bout.clicked.connect(lambda: self.fout.setText(str(
            QFileDialog.getSaveFileName(self.dialog, 'Save a Diff file',
                                        path.expanduser("~"), ';;(*.diff)'))))
        vboxg1 = QVBoxLayout(self.group1)
        for each_widget in (QLabel('Original file full path'),
                            self.file1, self.borig,
                            QLabel('Modified file full path'),
                            self.file2, self.bmodi,
                            QLabel('Output file full Path'),
                            self.fout, self.bout,
                            QLabel('Diff Output Format'), self.frmt,
                            QLabel('Diff REGEX to Ignore (ADVANCED)'),
                            self.regex):
            vboxg1.addWidget(each_widget)

        self.group2 = QGroupBox()
        self.group2.setTitle('Options')
        self.nwfl = QCheckBox('Treat new files as Empty')
        self.smll = QCheckBox('Look for smaller changes')
        self.lrgf = QCheckBox('Optimize for large files')
        self.case = QCheckBox('Ignore case changes on content')
        self.cnvt = QCheckBox('Convert Tabs to Spaces')
        self.blnk = QCheckBox('Ignore added or removed Blank lines')
        self.spac = QCheckBox('Ignore changes in amount of Spaces')
        self.whit = QCheckBox('Ignore ALL white Spaces')
        self.tabz = QCheckBox('Ignore changes by Tab expansions')
        self.sprs = QCheckBox('Remove Space or Tab before empty lines')
        self.filn = QCheckBox('Ignore case when comparing file names')
        self.tbs = QComboBox(self.group2)
        self.tbs.addItems(['4', '6', '8', '10', '2'])
        self.nice = QComboBox(self.group2)
        self.nice.addItems(['20', '15', '10', '5', '0'])
        vboxg2 = QVBoxLayout(self.group2)
        for each_widget in (self.nwfl, self.smll, self.lrgf, self.case,
                            self.cnvt, self.blnk, self.spac, self.whit,
                            self.tabz, self.sprs, self.filn,
                            QLabel('Diff Tabs-to-Spaces Size'), self.tbs,
                            QLabel('Diff Backend CPU Priority'), self.nice):
            vboxg2.addWidget(each_widget)
            try:
                each_widget.setToolTip(each_widget.text())
            except:
                each_widget.setToolTip(each_widget.currentText())
            each_widget.setCursor(QCursor(Qt.PointingHandCursor))

        group3 = QGroupBox()
        group3.setTitle('Even More Options')
        self.plai = QCheckBox('Force treat all files as plain text')
        self.nocr = QCheckBox('Force strip trailing carriage return')
        self.ridt = QCheckBox('Report when two files are identical')
        self.nocm = QCheckBox('Do not output common lines')
        self.rdif = QCheckBox('Report only when files differ')
        self.clip = QCheckBox('Copy Diff to Clipboard when done')
        self.noti = QCheckBox('Use system Notification when done')
        self.pret = QCheckBox('Align all Tabs by prepending a Tab')
        self.lolz = QCheckBox('Output Diff in two equal columns')
        self.odif = QCheckBox('Open Diff with Ninja-IDE when done')
        self.plac = QCheckBox('Make an Awesome Diff view when done')
        self.wdth = QComboBox(group3)
        self.wdth.addItems(['80', '100', '120', '130', '250', '500', '999999'])
        self.bcknd = QComboBox(group3)
        self.bcknd.addItems(['diff', 'diff.py'])
        self.bcknd.setDisabled(True)  #TODO this feature needs work
        vboxg3 = QVBoxLayout(group3)
        for each_widget in (self.plai, self.nocr, self.ridt, self.nocm,
                            self.rdif, self.pret, self.clip, self.noti,
                            self.lolz, self.odif, self.plac,
                            QLabel('Diff Maximum Total Width'), self.wdth,
                            QLabel('Diff Backend (EXPERIMENTAL)'), self.bcknd):
            vboxg3.addWidget(each_widget)
            try:
                each_widget.setToolTip(each_widget.text())
            except:
                each_widget.setToolTip(each_widget.currentText())
            each_widget.setCursor(QCursor(Qt.PointingHandCursor))

        for widget_should_be_checked in (self.nwfl, self.smll, self.lrgf,
                                   self.clip, self.cnvt, self.plai, self.noti):
            widget_should_be_checked.setChecked(True)

        container = QWidget()
        hbox = QHBoxLayout(container)
        for each_widget in (self.group2, self.group1, group3):
            hbox.addWidget(each_widget)

        buttons = QDialogButtonBox()
        buttons.resize(self.dialog.size().width(), buttons.size().height() * 2)
        buttons.setOrientation(Qt.Horizontal)
        buttons.setStandardButtons(
            QDialogButtonBox.Ok |
            QDialogButtonBox.Cancel |
            QDialogButtonBox.Close |
            QDialogButtonBox.Help)
        buttons.setCenterButtons(False)
        buttons.helpRequested.connect(lambda: QMessageBox.about(
            self.dialog, __doc__,
            ''.join((__doc__, ' GUI and Visualizer Plugin,', linesep,
            'version ', __version__, ', (', __license__, '), by ', linesep,
            __author__, ', ( ', __email__, ' ).', linesep))))
        buttons.rejected.connect(self.dialog.close)
        buttons.accepted.connect(self.make_diff)

        info = QLabel(''.join(('<b> Current Backend Diff Engine: </b>',
                      getoutput('diff --version').split(linesep)[0])))

        vbox = QVBoxLayout(self.dialog)
        for each_widget in (
                QLabel('<center><h2> Ninja IDE Diff and Patch </h2></center>'),
                container, info, buttons):
            vbox.addWidget(each_widget)

        self.dialog.resize(1024, self.dialog.size().height())
        self.dialog.exec_()

    def make_diff(self):
        ' make the diff '
        diff_command = ''.join((
        'nice --adjustment=', str(self.nice.currentText()).strip(), ' ',
        str(self.bcknd.currentText()).strip(), ' --',
        str(self.frmt.currentText()).strip().lower(),

        ' --new-file ' if self.nwfl.isChecked() is True else '',
        ' --minimal ' if self.smll.isChecked() is True else '',
        ' --speed-large-files ' if self.lrgf.isChecked() is True else '',
        ' --ignore-self.case ' if self.case.isChecked() is True else '',
        ' --expand-tabs ' if self.cnvt.isChecked() is True else '',
        ' --ignore-blank-lines ' if self.blnk.isChecked() is True else '',
        ' --ignore-space-change ' if self.spac.isChecked() is True else '',
        ' --ignore-all-space ' if self.whit.isChecked() is True else '',
        ' --ignore-tab-expansion ' if self.tabz.isChecked() is True else '',
        ' --suppress-blank-empty ' if self.sprs.isChecked() is True else '',
        ' --ignore-file-name-case ' if self.filn.isChecked() is True else '',
        ' --text ' if self.plai.isChecked() is True else '',
        ' --strip-trailing-cr ' if self.nocr.isChecked() is True else '',
        ' --suppress-common-lines ' if self.nocm.isChecked() is True else '',
        ' --initial-tab ' if self.pret.isChecked() is True else '',
        ' --side-by-side ' if self.lolz.isChecked() is True else '',

        ' --tabsize=', str(self.tbs.currentText()).strip(),
        ' --width=', str(self.wdth.currentText()).strip(),

        str(' --ignore-matching-lines=' + str(self.regex.text()).strip())
                           if str(self.regex.text()).strip() is not '' else '',
        ' ',
        path.abspath(str(self.file1.text()))
                    if str(self.file1.text()).strip() is not '' else __file__,
        ' ',
        path.abspath(str(self.file2.text()))
                    if str(self.file2.text()).strip() is not '' else __file__
        ))

        print(diff_command)
        diff_output = getoutput(diff_command)
        try:
            print(' INFO: OK, Saving new Diff to disk...')
            output_file = file(path.abspath(str(self.fout.text())), 'w')
            output_file.write(diff_output)
            output_file.close()
        except:
            print(' ERROR: FAIL, Can not save Diff to disk!')
        if self.clip.isChecked() is True:
            print(' INFO: OK, Diff Copied to Clipboard...')
            QApplication.clipboard().setText(diff_output)
        if self.noti.isChecked() is True:
            call('notify-send [Ninja-IDE] ¡Diff_is_Ready!', shell=True)
        if self.odif.isChecked() is True:
            print(' INFO: OK, Opening Diff with Ninja-IDE')
            call('ninja-ide ' + path.abspath(str(self.fout.text())), shell=True)

        self.diff_path = path.abspath(str(self.fout.text()))
        return self.diff_path


###############################################################################


if __name__ == "__main__":
    ' main loop, for testing purposes '
    import sys
    app = QApplication(sys.argv)
    main = DiffGUI()
    sys.exit(app.exec_())
