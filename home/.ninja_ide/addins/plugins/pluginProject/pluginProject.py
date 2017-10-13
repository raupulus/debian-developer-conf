# -*- coding: UTF-8 -*-

import os
try:
    import json
except ImportError:
    import simplejson as json

from PyQt4.QtGui import QMessageBox
from PyQt4.QtCore import Qt

from ninja_ide.core import plugin
from ninja_ide.core import plugin_interfaces
from ninja_ide.core import file_manager
from ninja_ide.tools import json_manager

from menu import Menu
from wizard import PagePluginProperties

PROJECT_TYPE = "NINJA-Plugin-Project"


class PluginProject(plugin.Plugin):
    def initialize(self):
        global PROJECT_TYPE
        self.explorer_s = self.locator.get_service('explorer')
        # Set a project handler for NINJA-IDE Plugin
        self.explorer_s.set_project_type_handler(PROJECT_TYPE,
                PluginProjectHandler(self.locator))


class PluginProjectHandler(plugin_interfaces.IProjectTypeHandler):

    EXT = '.plugin'

    def __init__(self, locator):
        self.locator = locator

    def get_context_menus(self):
        return (Menu(self.locator), )

    def get_pages(self):
        return [PagePluginProperties(self.locator)]

    def on_wizard_finish(self, wizard):
        global PROJECT_TYPE
        ids = wizard.pageIds()
        # Manipulate default data for NINJA-IDE projects
        page = wizard.page(ids[2])
        path = unicode(page.txtPlace.text())
        if not path:
            QMessageBox.critical(self, self.tr("Incorrect Location"),
                self.tr("The project couldn\'t be create"))
            return
        project = {}
        name = unicode(page.txtName.text())
        project['name'] = name
        project['project-type'] = PROJECT_TYPE
        project['description'] = unicode(page.txtDescription.toPlainText())
        project['license'] = unicode(page.cboLicense.currentText())
        project['venv'] = unicode(page.vtxtPlace.text())

        # Manipulate plugin project data
        page = wizard.page(ids[1])
        # Create a folder to contain all the project data (<path>/<name>/)
        path = os.path.join(path, name)
        file_manager.create_folder(path, add_init_file=False)
        # Create the .nja file
        json_manager.create_ninja_project(path, name, project)

        plugin_dict = self.create_descriptor(page, path)
        self.create_plugin_class(page, path, plugin_dict)
        # Load the project!
        wizard._load_project(path)

    def create_descriptor(self, page, path):
        plugin = {}

        module = unicode(page.txtModule.text())
        plugin['module'] = module
        className = str(page.txtClass.text())
        plugin['class'] = className
        authors = unicode(page.txtAuthors.text())
        plugin['authors'] = authors
        url = unicode(page.txtUrl.text())
        plugin['url'] = url
        version = unicode(page.txtVersion.text())
        plugin['version'] = version

        fileName = os.path.join(path, module + self.EXT)
        # Create the .plugin file with metadata
        self.create_file(fileName, plugin)
        # Return the dictionary
        return plugin

    def create_plugin_class(self, page, path, plugin_dict):
        module = plugin_dict['module']
        className = plugin_dict['class']
        completed = False
        # Start the template
        content = TEMPLATE_PLUGIN_BEGIN % className

        if page.checkEditorS.checkState() == Qt.Checked:
            content += TEMPLATE_EDITOR_S
            completed = True

        if page.checkToolbarS.checkState() == Qt.Checked:
            content += TEMPLATE_TOOLBAR_S
            completed = True

        if page.checkMenuPluginS.checkState() == Qt.Checked:
            content += TEMPLATE_MENU_S
            completed = True

        if page.checkMiscS.checkState() == Qt.Checked:
            content += TEMPLATE_MISC_S
            completed = True

        if page.checkExplorerS.checkState() == Qt.Checked:
            content += TEMPLATE_EXPLORER_S
            completed = True

        if not completed:
            content += TEMPLATE_PASS_STATMENT

        content += TEMPLATE_PLUGIN_FINISH
        content = content
        # Create the folder
        file_manager.create_folder(os.path.join(path, module))
        # Create the file
        fileName = os.path.join(os.path.join(path, module), module + '.py')
        # Write to the file
        file_manager.store_file_content(fileName, content)
        # Create the __init__.py with the imports!
        file_manager.create_init_file_complete(os.path.join(path, module))

    def create_file(self, fileName, structure):
        f = open(fileName, mode='w')
        json.dump(structure, f, indent=2)
        f.close()


###############################################################################
# TEMPLATES
###############################################################################

TEMPLATE_PLUGIN_BEGIN = """# -*- coding: UTF-8 -*-

from ninja_ide.core import plugin


class %s(plugin.Plugin):
    def initialize(self):
        # Init your plugin"""

TEMPLATE_PASS_STATMENT = """
        pass"""

TEMPLATE_EDITOR_S = """
        self.editor_s = self.locator.get_service('editor')"""

TEMPLATE_TOOLBAR_S = """
        self.toolbar_s = self.locator.get_service('toolbar')"""

TEMPLATE_MENU_S = """
        self.menuApp_s = self.locator.get_service('menuApp')"""

TEMPLATE_MISC_S = """
        self.misc_s = self.locator.get_service('misc')"""

TEMPLATE_EXPLORER_S = """
        self.explorer_s = self.locator.get_service('explorer')"""

TEMPLATE_PLUGIN_FINISH = """

    def finish(self):
        # Shutdown your plugin
        pass

    def get_preferences_widget(self):
        # Return a widget for customize your plugin
        pass
"""
