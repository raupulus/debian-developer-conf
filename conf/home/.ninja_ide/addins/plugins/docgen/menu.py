# *-* coding: UTF-8 *-*

import os
import zipfile

from PyQt4.QtGui import QMenu
from PyQt4.QtGui import QMessageBox
from PyQt4.QtCore import SIGNAL
from PyQt4.QtCore import QProcess

from ninja_ide import resources
from ninja_ide.tools import json_manager


class Menu(QMenu):

    def __init__(self, locator):
        QMenu.__init__(self, 'Plugin Tools')
        self._locator = locator
        self.explorer_s = self._locator.get_service('explorer')
        self._proc = QProcess(self)
        action_zip = self.addAction('Package This Plugin!')
        self.connect(action_zip, SIGNAL("triggered()"), self.create_zip)
        action_run = self.addAction('Test This Plugin on NINJA-IDE!')
        self.connect(action_run, SIGNAL("triggered()"), self.run_plugin)

    def run_plugin(self):
        p_path = self.explorer_s.get_tree_projects()._get_project_root().path
        ninja_executable = resources.NINJA_EXECUTABLE
        args = ["--plugin", p_path]
        self._proc.startDetached(ninja_executable, args)

    def create_zip(self):
        folder = self.explorer_s.get_tree_projects()._get_project_root().path
        plugin = json_manager.read_ninja_plugin(folder)
        module = os.path.join(folder, plugin.get('module', 'module') + '.zip')
        self.create_zip_file(self.dir_entries(folder, True), module, folder)

    def create_zip_file(self, fileList, archive, relative):
        try:
            zipFile = zipfile.ZipFile(archive, mode='w')
            for fname in fileList:
                zipFile.write(fname, os.path.relpath(fname, relative))
            zipFile.close()

            QMessageBox.information(self, 'Package Created!',
                'The package has been created in\nthe project folder.')
        except Exception, reason:
            QMessageBox.information(self, 'Package Failed!',
                'The package has not been created in\nthe project folder.')

    def dir_entries(self, dir_name, subdir, *args):
        fileList = []
        for file in os.listdir(dir_name):
            dirfile = os.path.join(dir_name, file)
            if os.path.isfile(dirfile):
                if not args:
                    fileList.append(dirfile)
                else:
                    if os.path.splitext(dirfile)[1][1:] in args:
                        fileList.append(dirfile)
            elif os.path.isdir(dirfile) and subdir:
                fileList.extend(self.dir_entries(dirfile, subdir, *args))
        return fileList
