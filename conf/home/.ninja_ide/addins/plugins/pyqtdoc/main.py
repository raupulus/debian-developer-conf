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
" Ninja PyQt4 Doc "
__version__ = ' 0.1 '
__license__ = ' GPL '
__author__ = ' juancarlospaco '
__email__ = ' juancarlospaco@ubuntu.com '
__url__ = ''
__date__ = ' 05/09/2013 '
__prj__ = ' pyqtdoc '
__docformat__ = 'html'
__source__ = ''
__full_licence__ = ''


# imports
from webbrowser import open_new_tab

from PyQt4.QtGui import QIcon, QAction, QInputDialog

from ninja_ide.core import plugin


###############################################################################


class Main(plugin.Plugin):
    " Main Class "
    def initialize(self, *args, **kwargs):
        " Init Main Class "
        super(Main, self).initialize(*args, **kwargs)
        self.locator.get_service("menuApp").add_action(QAction(QIcon.fromTheme("help-about"), "PyQt4 Doc Search", self, triggered=lambda: open_new_tab('http://pyqt.sourceforge.net/Docs/PyQt4/{}.html'.format(str(QInputDialog.getText(None, __doc__, "Search PyQt4 Doc Reference for?:")[0]).strip().lower()))))


###############################################################################


if __name__ == "__main__":
    print(__doc__)
