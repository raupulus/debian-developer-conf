# -*- coding: UTF-8 -*-

import os
import pickle
try:
    import json
except ImportError:
    import simplejson as json

from PyQt4 import QtGui
from PyQt4.QtCore import Qt

from ninja_ide.core import plugin
from ninja_ide.core import plugin_interfaces
from ninja_ide.core import file_manager
from ninja_ide.tools import json_manager

from menu import Menu
from wizard import PagePluginProperties

from tokenize_util import token_def, token_args

PROJECT_TYPE = "NINJA-Plugin-Project"

class Docstring(list):
    'Subclass of list which makes handling the docstring easier.'
    def __init__(self, indent=0):
        super(Docstring, self).__init__()
        self.prefix = " " * indent

    def append(self, item):
        super(Docstring, self).append(self.prefix + item + '\n')

    def append_newline(self):
        super(Docstring, self).append('\n')

    def __str__(self):
        return u"{0}\n{1}{0}".format(self.prefix + "'''", "".join(self))

#TODO: make config stuff more error safe (e.g. keybinding)
#TODO: allow user to create several templates with certain type (e.g. sphinx)
#TODO: parse super classes and put in docstring
class DocGen(plugin.Plugin):
    def initialize(self):
        global PROJECT_TYPE
        self.explorer_s = self.locator.get_service('explorer')
        self.editor_s = self.locator.get_service('editor')
        self.menu_s = self.locator.get_service('menuApp')

        # set a project handler for NINJA-IDE Plugin
        self.explorer_s.set_project_type_handler(PROJECT_TYPE,
                DocGenHandler(self.locator))

        # get settings from config file
        self.config = None
        self.config_path = None
        self.doc_type = None
        self.keybinding = None
        self._update_config()

        # create settings window
        self.settings_win = SettingsWindow(None, self.config, self.config_path)

        # add menu entries
        #FIXME: implement as menu
        settings = QtGui.QAction("DocGen Settings", self)
        settings.triggered.connect(self.settings_win.show)

        gen_doc = QtGui.QAction("Generate Docstring", self)
        gen_doc.triggered.connect(self.generate_doc)
        gen_doc.setShortcut(QtGui.QKeySequence(self.keybinding))

        self.menu_s.add_action(gen_doc)
        self.menu_s.add_action(settings)

    def generate_doc(self):
        '''
        Main function. Tries to find either an empty line, class or function
        definition, generates the docstring and inserts it.
        '''
        # make sure config is up to date
        self._update_config()

        # get the editor and its content
        editor = self.editor_s.get_editor()
        text = editor.get_text()

        # get start index for current line
        pos = editor.get_cursor_position()
        start = text[:pos].rfind('\n') + 1 #TODO: is this reliable?

        # get definition type and index for end of definition
        keyword_to_type = {'def': 'fnc', 'class': 'cls', '': 'mod'}

        def_type, index = token_def(text[start:])

        def_type = keyword_to_type[def_type]
        end = start + index

        # create a call-table which contains the markup specific functions
        # more to come! (hopefully)
        call = {
            'custom': { 'fnc': lambda: self._general_doc('fnc', text[start:end]),
                        'cls': lambda: self._general_doc('cls', text[start:end]),
                        'mod': lambda: self._general_doc('mod', None) },

            'sphinx': { 'fnc': lambda: self._sphinx_function(text[start:end]),
                        'cls': lambda: self._general_doc('cls', text[start:end]),
                        'mod': lambda: self._general_doc('mod', None) }
            }

        doc = call[self.doc_type][def_type]()

        if doc and start <= end:
            editor.set_cursor_position(end) # set cursor to end of line
            self.editor_s.insert_text('\n' + unicode(doc))

    def _general_doc(self, header_type, header):
        '''
        Gets a the type of definition (mod, cls or fnc) and the current line.
        Returns a Docstring object containing the configured lines.
        '''
        keyword = { 'cls': 'class',
                    'fnc': 'def' }

        if header:
            doc = Docstring(indent=header.find(keyword[header_type]) + 4)
        else:
            doc = Docstring()

        for line in self.config[self.doc_type][header_type].split('\n'):
            doc.append(line)

        return doc

    def _sphinx_function(self, header):
        'Applies special DocGen directives for Sphinx markup to functions.'
        # get arguments from syntax parser - the only reliable way to do it
        args = token_args(header)

        doc = Docstring(indent=header.find('def') + 4)

        for line in self.config['sphinx']['fnc'].split('\n'):
            if ':params:' in line:
                indent = " " * line.find(':params:')
                types = ':types:' in line

                for arg in args:
                    if arg == 'self': continue
                    doc.append(indent + ':param %s: ' % arg)
                    if types: doc.append(indent + ':type %s: ' % arg)
            else:
                doc.append(line)

        return doc

    def _get_config(self, path='~/.ninja_ide/addins/plugins/docgen/config'):
        '''
        Reads current config or creates default config if none is found.
        Returns the ConfigParser object and the path to the config file.
        '''
        path = os.path.expanduser(path)
        config_file = None

        if not os.path.isfile(path):
            # no config file yet, create one with default values
            config_file = open(path, 'w')
            config = {}

            config['general'] = { 'doc_type': 'sphinx',
                                  'keybinding': 'F8' }

            config['custom'] = { 'mod': '', 'cls': '', 'fnc': '' }

            config['sphinx'] = {
                'mod': ('Created on <date>\n\n' +
                        '.. moduleauthor:: Firstname Lastname <firstname@example.com>\n\n' +
                        ':synopsis:'),
                'cls': '.. codeauthor:: Firstname Lastname <firstname@example.com>',
                'fnc': ('.. codeauthor:: Firstname Lastname <firstname@example.com>\n\n' +
                        ':params: :types:\n\n' +
                        ':returns: \n\n' +
                        ':raise: ')
            }

            pickle.dump(config, config_file)
        else: # config file found - read it
            config_file = open(path, 'r')
            config = pickle.load(config_file)

        config_file.close()
        return config, path

    def _update_config(self):
        'Helper function to read/update config.'
        self.config, self.config_path = self._get_config()
        self.doc_type = self.config['general']['doc_type']
        self.keybinding = self.config['general']['keybinding']


class SettingsWindow(QtGui.QDialog):
    def __init__(self, parent, config, path):
        QtGui.QDialog.__init__(self, parent)

        self.parent = parent
        self.config = config
        self.config_path = path

        # set window properties
        self.resize(560, 680)
        self.setMinimumSize(320, 400)
        self.setWindowTitle('DocGen - Settings')

        # create LineEdit for keybinding
        self.keybinding_l = QtGui.QLabel("Key Binding:")
        self.keybinding = QtGui.QLineEdit(self)

        # create ComboBox for doctype
        self.doc_type_l = QtGui.QLabel("Documentaion Type:")
        self.doc_type = QtGui.QComboBox(self)

        # create TabWidget for different doc types
        self.tab = QtGui.QTabWidget(self)

        # create TextEdits for each template
        sections = [sec for sec in self.config if sec != 'general']

        self.edits = {}
        for sec in sections:
            self.edits[sec] = TemplateEdit() # own class - see below
            self.tab.addTab(self.edits[sec], sec.capitalize())

        # button to write config to file
        self.but_save = QtGui.QPushButton('Save', self)

        def but_save_slot():
            self._write_config()
            self.hide()

        self.but_save.clicked.connect(but_save_slot)

        # create layout
        grid = QtGui.QGridLayout(self)

        grid.addWidget(self.keybinding_l, 0, 0)
        grid.addWidget(self.keybinding,   0, 1)
        grid.addWidget(self.doc_type_l,   1, 0)
        grid.addWidget(self.doc_type,     1, 1)
        grid.addWidget(self.tab,          2, 0, 1, 2)
        grid.addWidget(self.but_save,     3, 0, 1, 2)

        self.setLayout(grid)

        # read current config
        self.keybinding.setText(self.config['general']['keybinding'])

        for i, sec in enumerate(sections):
            self.doc_type.addItem(sec.capitalize())
            if sec == self.config['general']['doc_type']:
                self.doc_type.setCurrentIndex(i)
                self.tab.setCurrentIndex(i)

            self.tab.addTab(None, sec)

        for sec, edit in self.edits.items():
            edit.mod.setText(self.config[sec]['mod'])
            edit.cls.setText(self.config[sec]['cls'])
            edit.fnc.setText(self.config[sec]['fnc'])

    def _write_config(self):
        # set global config to new values
        self.config['general']['keybinding'] = self.keybinding.text()

        self.config['general']['doc_type'] = self.doc_type.currentText().lower()

        for sec, edit in self.edits.items():
            self.config[sec]['mod'] = edit.mod.toPlainText()
            self.config[sec]['cls'] = edit.cls.toPlainText()
            self.config[sec]['fnc'] = edit.fnc.toPlainText()

        # write new config to file
        with open(self.config_path, 'w') as config_file:
            pickle.dump(self.config, config_file)


class TemplateEdit(QtGui.QWidget):
    def __init__(self):
        super(TemplateEdit, self).__init__()

        # create TextEdits for each template
        self.mod_l = QtGui.QLabel("Module Template:")
        self.mod = QtGui.QTextEdit(self)
        self.mod.setLineWrapMode(QtGui.QTextEdit.NoWrap)

        self.cls_l = QtGui.QLabel("Class Template:")
        self.cls = QtGui.QTextEdit(self)
        self.cls.setLineWrapMode(QtGui.QTextEdit.NoWrap)

        self.fnc_l = QtGui.QLabel("Function Template:")
        self.fnc = QtGui.QTextEdit(self)
        self.fnc.setLineWrapMode(QtGui.QTextEdit.NoWrap)

        # create layout and add TextEdits
        vbox = QtGui.QVBoxLayout(self)

        vbox.addWidget(self.mod_l)
        vbox.addWidget(self.mod)
        vbox.addWidget(self.cls_l)
        vbox.addWidget(self.cls)
        vbox.addWidget(self.fnc_l)
        vbox.addWidget(self.fnc)

        self.setLayout(vbox)


class DocGenHandler(plugin_interfaces.IProjectTypeHandler):

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
            QtGui.QMessageBox.critical(self, self.tr("Incorrect Location"),
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
