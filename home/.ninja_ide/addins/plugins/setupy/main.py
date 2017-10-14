# -*- coding: utf-8 -*-
# PEP8:NO, LINT:OK, PY3:NO


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
" Ninja Setup.py Creator "
__version__ = ' 0.6 '
__license__ = ' GPL '
__author__ = ' juancarlospaco '
__email__ = ' juancarlospaco@ubuntu.com '
__url__ = ''
__date__ = ' 05/09/2013 '
__prj__ = ' setupy '
__docformat__ = 'html'
__source__ = ''
__full_licence__ = ''


# imports
from os import linesep
from getpass import getuser
from datetime import datetime

from PyQt4.QtGui import (QIcon, QAction, QDialog, QGroupBox, QDoubleSpinBox,
    QLabel, QPushButton, QGraphicsDropShadowEffect, QLineEdit, QComboBox,
    QColor, QVBoxLayout, QCheckBox, QSpinBox, QApplication)

from PyQt4.QtCore import Qt

from ninja_ide.core import plugin


# constants
HELPMSG = ''.join((__doc__, __version__, __license__, 'by', __author__))


###############################################################################


class Main(plugin.Plugin):
    " Main Class "
    def initialize(self, *args, **kwargs):
        " Init Main Class "
        super(Main, self).initialize(*args, **kwargs)
        self.locator.get_service("menuApp").add_action(QAction(QIcon.fromTheme(
            "edit-select-all"), "Create Setup.py", self, triggered=lambda:
            self.get_dialog()))
        self.dialog, self.group0 = QDialog(), QGroupBox()
        self.group0.setTitle(' Setup.py Creator ')
        self.pkgname, self.version = QLineEdit(), QDoubleSpinBox()
        self.urlproj, self.licence = QLineEdit('https://www.'), QLineEdit('GPL')
        self.authors, self.emails = QLineEdit(getuser()), QLineEdit('@mail.com')
        self.descrip, self.button = QLineEdit(), QPushButton('Make Setup.py !')
        self.choices, self.indents = QComboBox(), QSpinBox()
        self.metada = QCheckBox('Use SheBang and Metadata')
        self.nosetest = QCheckBox('Use Nose Tests Framework integration')
        self.metada.setChecked(True)
        self.chckbx1 = QCheckBox('Copy output to ClipBoard when done')
        self.choices.addItems(['from distutils.core import setup',
                               'import distutils.core'])
        self.indents.setValue(4)
        self.indents.setMaximum(8)
        self.indents.setMinimum(0)
        self.indents.setSingleStep(2)
        self.version.setValue(0.1)
        self.version.setMinimum(0.1)
        self.version.setDecimals(1)
        self.version.setSingleStep(0.1)
        self.button.setMinimumSize(400, 50)
        self.button.clicked.connect(self.make_setupy)
        glow = QGraphicsDropShadowEffect(self)
        glow.setOffset(0)
        glow.setBlurRadius(99)
        glow.setColor(QColor(99, 255, 255))
        self.button.setGraphicsEffect(glow)
        inf = QLabel('''<a href="http://guide.python-distribute.org/future.html"
                  ><center><i>INFO: This is Deprecated Legacy Packaging.</a>''')
        inf.setTextInteractionFlags(Qt.LinksAccessibleByMouse)
        inf.setOpenExternalLinks(True)
        vboxg0 = QVBoxLayout(self.group0)
        for each_widget in (QLabel('<b>Package Name'), self.pkgname,
            QLabel('<b>Version'), self.version, QLabel('<b>URL'), self.urlproj,
            QLabel('<b>Licence'), self.licence, QLabel('<b>Author'),
            self.authors, QLabel('<b>Mail'), self.emails,
            QLabel('<b>Description'), self.descrip, QLabel('<b>Imports'),
            self.choices, QLabel('<b>Indentation Spaces '), self.indents,
            self.metada, self.chckbx1, self.nosetest, inf,
            QLabel('<center><small><i>{}'.format(HELPMSG)), self.button):
            vboxg0.addWidget(each_widget)
            try:
                each_widget.setToolTip(each_widget.text())
            except:
                pass
        QVBoxLayout(self.dialog).addWidget(self.group0)

    def get_dialog(self):
        ' show dialog auto fill data '
        self.pkgname.setText(str(self.locator.get_service('explorer'
            ).get_tree_projects()._get_project_root().name).strip().lower(
            ) if self.locator.get_service('explorer').get_tree_projects(
            )._get_project_root().name is not '' else 'untitled')
        self.urlproj.setText(str(self.locator.get_service('explorer'
            ).get_tree_projects()._get_project_root().url).strip().lower(
            ) if self.locator.get_service('explorer').get_tree_projects(
            )._get_project_root().url is not '' else 'https://www.')
        self.licence.setText(str(self.locator.get_service('explorer'
            ).get_tree_projects()._get_project_root().license).strip().upper(
            ) if self.locator.get_service('explorer').get_tree_projects(
            )._get_project_root().license is not '' else 'GPL')
        self.descrip.setText(str(self.locator.get_service('explorer'
            ).get_tree_projects()._get_project_root().description).strip())
        self.dialog.show()

    def make_setupy(self):
        ' create setup.py file '
        setupy = str('\n'.join((
            '#!/usr/bin/env python' if self.metada.isChecked() is True else '',
            '# -*- coding: utf-8 -*-' if self.metada.isChecked() is True else '',
            linesep * 2 + '# metadata' if self.metada.isChecked() is True else '',
            '" {} "'.format(self.descrip.text()) if self.metada.isChecked() is True else '',
            '__version__ = " {} "'.format(str(self.version.text()).replace(',', '.')) if self.metada.isChecked() is True else '',
            '__license__ = " {} "'.format(self.licence.text()) if self.metada.isChecked() is True else '',
            '__author__ = " {} "'.format(self.authors.text()) if self.metada.isChecked() is True else '',
            '__email__ = " {} "'.format(self.emails.text()) if self.metada.isChecked() is True else '',
            '__url__ = " {} "'.format(self.urlproj.text()) if self.metada.isChecked() is True else '',
            '__date__ = " {} "'.format(datetime.now().isoformat().split('.')[0]) if self.metada.isChecked() is True else '',
            '__prj__ = " {} "'.format(self.pkgname.text()) if self.metada.isChecked() is True else '',
            linesep * 2 + '# imports' if self.metada.isChecked() is True else '',
            str(self.choices.currentText()),
            linesep,
            'setup(' if self.choices.currentIndex() is 0 else 'distutils.core.setup(',
            '{}name="{}",'.format(' ' * self.indents.value(), self.pkgname.text()),
            '{}version="{}",'.format(' ' * self.indents.value(), str(self.version.text()).replace(',', '.')),
            '{}packages=[""],'.format(' ' * self.indents.value()),
            '{}url="{}",'.format(' ' * self.indents.value(), self.urlproj.text()),
            '{}download_url="{}",'.format(' ' * self.indents.value(), self.urlproj.text()),
            '{}license="{}",'.format(' ' * self.indents.value(), self.licence.text()),
            '{}author="{}",'.format(' ' * self.indents.value(), self.authors.text()),
            '{}author_email="{}",'.format(' ' * self.indents.value(), self.emails.text()),
            '{}maintainer="{}",'.format(' ' * self.indents.value(), self.authors.text()),
            '{}maintainer_email="{}",'.format(' ' * self.indents.value(), self.emails.text()),
            '{}description="{}",'.format(' ' * self.indents.value(), self.descrip.text()),
            '{}long_description="{}",'.format(' ' * self.indents.value(), self.descrip.text()),
            '{}test_suite="nose.collector",'.format(' ' * self.indents.value())  if self.nosetest.isChecked() is True else '',
            '{}setup_requires=["nose>=1.0"],'.format(' ' * self.indents.value())  if self.nosetest.isChecked() is True else '',
            ')'
        ))).strip()
        if self.chckbx1.isChecked() is True:
            QApplication.clipboard().setText(setupy)
        self.locator.get_service("editor").add_editor(content=setupy,
                                                      syntax='python')
        self.dialog.hide()


###############################################################################


if __name__ == "__main__":
    print(__doc__)
