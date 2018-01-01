#!/usr/bin/env python
# -*- coding: utf-8 *-*
"""
    Debugger plugin for Ninja-IDE.
"""

import os
import time
import logging

import ninja_ide.gui
import ninja_ide.core.plugin
import ninja_ide.core.settings
import ninja_ide.gui.main_panel.main_container

from PyQt4.QtCore import SIGNAL
from PyQt4.QtCore import Qt
from PyQt4.QtCore import pyqtSignal
from PyQt4.QtCore import QPoint
from PyQt4.QtCore import QProcess
from PyQt4.QtCore import QThread
from PyQt4.QtGui import QIcon
from PyQt4.QtGui import QMenu
from PyQt4.QtGui import QWidget
from PyQt4.QtGui import QAction
from PyQt4.QtGui import QToolTip
from PyQt4.QtGui import QTabWidget
from PyQt4.QtGui import QMessageBox
from PyQt4.QtGui import QTextBlockFormat
from PyQt4.QtGui import QVBoxLayout
from PyQt4.QtGui import QHBoxLayout
from PyQt4.QtGui import QSpacerItem
from PyQt4.QtGui import QSizePolicy

import debugger_plugin.core.models
import debugger_plugin.core.symbols
import debugger_plugin.gui.resources
import debugger_plugin.gui.threads
import debugger_plugin.gui.watches
import debugger_plugin.gui.providers

import ndb3.rpc


class DebugPlugin(ninja_ide.core.plugin.Plugin):
    """
    Plugin that enables debugging scripts for Ninja-IDE.
    """
    instance = None

    def initialize(self):
        """
        Inicializes the DebugPlugin.
        """
        DebugPlugin.instance = self

        # Fix some incompatibilities with version 2.0
        if not hasattr(self, 'logger'):
            self.logger = logging.getLogger(__name__)
        if not hasattr(self, 'path'):
            self.path = os.path.dirname(__file__)

        self.logger.info("Initializing plugin.")

        # Basic services
        self.ide = None
        self.editor = self.locator.get_service('editor')
        self.toolbar = self.locator.get_service('toolbar')
        self.menuApp = self.locator.get_service('menuApp')
        self.misc = self.locator.get_service('misc')
        self.explorer = self.locator.get_service('explorer')

        # Debug attributes
        self.debugger_script = os.path.join(self.path, "ndb3", "ndb3.py")
        self.debugger_adapter = ndb3.rpc.RPCDebuggerAdapterClient()

        # Breakpoints
        self._breakpoints = {}

        # UI
        self._create_toolbar()
        self.threadsView = None

        self.logger.info("Successfully initialized")

    def finish(self):
        """Shuts down the plugin and the debugger client."""
        # Stop debugger if it's running.
        self.debug_stop()

    #
    # Actions
    #

    def debug_start(self, fn_run):
        """
        Start the debugging session. The specified function launches the
        debugging script.
        """
        self.logger.info("Session start.")
        # Activate the UI elements (watches widget, threads, etc)
        self._activate_ui()
        try:
            # Add environment variable to be able to debug django projects
            os.environ['RUN_MAIN'] = 'true'
            # Set execution options for this session.
            exec_opts = ninja_ide.core.settings.EXECUTION_OPTIONS
            ninja_ide.core.settings.EXECUTION_OPTIONS = "{0}".format(self.debugger_script)
            # Before start kill all executions
            self.ide.actions.kill_execution()
            # Run project
            fn_run()
            self._activate_debug_actions(True)
            # Wait for the debugger to start
            time.sleep(1)
            if self.debugger_adapter.connect(retries=3):
                # Clear ALL breakpoints before setting new ones.
                self.debugger_adapter.clear_breakpoints('')

                # Set all breakpoints currently in the editor
                for b, ls in ninja_ide.core.settings.BREAKPOINTS.items():
                    for l in ls:
                        # Add one to line number since the editor's line index
                        # starts at zero(0), while the debugger's index starts
                        # at one(1).
                        self.logger.debug("Breakpoint {0}:{1}".format(b, l))
                        self.debugger_adapter.set_breakpoint(b, l + 1)

                # Start event monitor
                self.monitor = EventWatcher(self.debugger_adapter.get_messages)
                self.monitor.newEvent.connect(self.process_event)
                self.monitor.start()

                # Start debugger
                self.debugger_adapter.start()
            else:
                QMessageBox.information(self.editor.get_editor(),
                     "Error when starting debugger",
                     "The debugger could not be started")
                self.debug_stop()
        finally:
            # Restore execution options
            ninja_ide.core.settings.EXECUTION_OPTIONS = exec_opts
        self.logger.info("Session ended.")

    def update_breakpoints(self):
        """Set the breakpoints currently active in the debugger."""
        if not self.debugger_adapter.is_alive():
            return

    def _move_editor_focus(self, file, line):
        """
        """
        # Check if the file we're getting is on the editor
        if not os.path.isfile(file):
            return

        # Open file (snippet taken from tree_projects_widget.py)
        ninja_ide.gui.main_panel.main_container.MainContainer().open_file(file)

        if line > 0:
            editor = self.editor.get_editor()
            editor.jump_to_line(line - 1)
            editor.setFocus()

    def _activate_debug_actions(self, activate = True):
        """
        Modifies the state of all the debugger actions. Also, changes the
        status of the start button to the oposite of the rest.
        """
        # Start is always backward from the other buttons
        self._btn_debug_file.setDisabled(activate)
        self._btn_debug_project.setDisabled(activate)

        # Set the activate for the rest of the buttons
        self._btn_cont.setDisabled(not activate)
        self._btn_stop.setDisabled(not activate)
        self._btn_into.setDisabled(not activate)
        self._btn_over.setDisabled(not activate)
        self._btn_out.setDisabled(not activate)

    #
    # Slots
    #

    def debug_project(self):
        """Start the debugging session of the main project file."""
        self.ide = ninja_ide.gui.ide.IDE()
        self.debug_start(self.ide.actions.execute_project)

    def debug_file(self):
        """Start the debugging session of the current file in the editor."""
        self.ide = ninja_ide.gui.ide.IDE()
        self.debug_start(self.ide.actions.execute_file)

    def select_thread(self):
        """
        Executed when an item in the threadview list is clicked. Can be
        a thread, or a stacktrace item.
        """
        stack = None
        tid = self.get_active_thread()
        if tid:
            stack = self.threads_model.get(tid).epointer
        if stack:
            self._move_editor_focus(stack.filename, stack.linenumber)
            self.watchesWidget.view.update()
        else:
            self._move_editor_focus("<nofile>", -1)

    #
    # User interface
    #

    def _activate_ui(self):
        """Creates and sets up the ui elements of the plugin."""

        # Model for Threads
        self.threads_model = debugger_plugin.core.models.ThreadGroup("Debug Session")

        # View for Threads
        self.threadsView = debugger_plugin.gui.threads.ThreadsView()
        self.threadsView.setContentProvider(debugger_plugin.gui.providers.ThreadsContentProvider())
        self.threadsView.setLabelProvider(debugger_plugin.gui.providers.ThreadsLabelProvider())
        self.threadsView.setInput(self.threads_model)

        self.connect(self.threadsView, SIGNAL("itemSelectionChanged()"), self.select_thread)

        # Expand top level item
        a = self.threadsView.topLevelItem(0)
        self.threadsView.expandItem(a)

        # Watches Widget
        self.watchesWidget = debugger_plugin.gui.watches.WatchesWidget()
        self.watchesWidget.itemChanged.connect(self.reevaluate_watch)

        # Save current widget before debug starts (to restore it later)
        self._old_active_widget_widget = self.explorer._explorer.currentWidget()

        # Configure tabs in explorer
        self.tabWidget = QWidget()
        vbox = QVBoxLayout(self.tabWidget)

        vbox.addWidget(self.threadsView)
        vbox.addSpacerItem(QSpacerItem(1, 0, QSizePolicy.Expanding))
        vbox.addWidget(self.watchesWidget)

        #self.tabWidget.addTab(self.threadsView, "Threads")
        #self.tabWidget.addTab(self.watchesWidget, "Watches")
        self.explorer.add_tab(self.tabWidget, "Debug")
        self.explorer._explorer.setCurrentWidget(self.tabWidget)

        # Install mouse handler
        self.__install_mouse_handler()

    def _deactivate_ui(self):
        """Remove all the debugging ui elements from the editor."""
        # Remove mouse move handler
        self.__uninstall_mouse_handler()
        # Restore active widget on explorer container
        self.explorer._explorer.setCurrentWidget(self._old_active_widget_widget)
        # Remove threads container
        self.explorer._explorer.removeTab(self.explorer._explorer.indexOf(self.tabWidget))

    def _create_toolbar(self):
        """
        Creates the toolbar to control the DebugPlugin. Add the icons and
        the actions in a disabled state.
        """
        # Debug Project
        self._btn_debug_project = QAction(QIcon(debugger_plugin.gui.resources.RES_ICON_START),
                                  debugger_plugin.gui.resources.RES_STR_DEBUG_PROJECT_START,
                                  self)
        self.connect(self._btn_debug_project, SIGNAL('triggered()'), self.debug_project)

        # Debug File
        self._btn_debug_file = QAction(QIcon(debugger_plugin.gui.resources.RES_ICON_START),
                                  debugger_plugin.gui.resources.RES_STR_DEBUG_FILE_START,
                                  self)
        self.connect(self._btn_debug_file, SIGNAL('triggered()'), self.debug_file)

        # Stop debug session
        self._btn_stop = QAction(QIcon(debugger_plugin.gui.resources.RES_ICON_STOP),
                                 debugger_plugin.gui.resources.RES_STR_DEBUG_STOP,
                                 self)
        self.connect(self._btn_stop, SIGNAL('triggered()'), self.debug_stop)

        # Continue
        self._btn_cont = QAction(QIcon(debugger_plugin.gui.resources.RES_ICON_CONT),
                                 debugger_plugin.gui.resources.RES_STR_DEBUG_CONTINUE,
                                 self)
        self.connect(self._btn_cont, SIGNAL('triggered()'), self.debug_cont)

        # Step into
        self._btn_into = QAction(QIcon(debugger_plugin.gui.resources.RES_ICON_INTO),
                                 debugger_plugin.gui.resources.RES_STR_DEBUG_STEPINTO,
                                 self)
        self.connect(self._btn_into, SIGNAL('triggered()'), self.debug_into)

        # Step over
        self._btn_over = QAction(QIcon(debugger_plugin.gui.resources.RES_ICON_OVER),
                                 debugger_plugin.gui.resources.RES_STR_DEBUG_STEPOVER,
                                 self)
        self.connect(self._btn_over, SIGNAL('triggered()'), self.debug_over)

        # Step out
        self._btn_out = QAction(QIcon(debugger_plugin.gui.resources.RES_ICON_OUT),
                                debugger_plugin.gui.resources.RES_STR_DEBUG_STEPOUT,
                                self)
        self.connect(self._btn_out, SIGNAL('triggered()'), self.debug_out)

        # Add start button to menu
        menu = QMenu("Debug", self.menuApp._plugins_menu)
        menu.addAction(self._btn_debug_file)
        menu.addAction(self._btn_debug_project)
        menu.addSeparator()
        menu.addAction(self._btn_cont)
        menu.addAction(self._btn_stop)
        menu.addAction(self._btn_into)
        menu.addAction(self._btn_over)
        menu.addAction(self._btn_out)

        # Add Menu
        self.menuApp.add_menu(menu)

        # Add buttons to toolbar
        self.toolbar.add_action(self._btn_cont)
        self.toolbar.add_action(self._btn_stop)
        self.toolbar.add_action(self._btn_into)
        self.toolbar.add_action(self._btn_over)
        self.toolbar.add_action(self._btn_out)

        # Start disabled
        self._activate_debug_actions(False)

    def __install_mouse_handler(self):
        """
        Installs a new mouse event handler for the ninja-ide. The new handler
        observates the position and evaluates any symbol under the mouse cursor
        and show its value. Doesn't remove old behavior, it just execute it
        after the custom handler is done.
        """
        editor_widget = self.editor.get_editor()
        self.sym_finder = dict()

        # Save old mouse event
        self.__old_mouse_event = editor_widget.mouseMoveEvent

        # New custom mouse handler
        def custom_mouse_movement(event):
            try:
                # If no thread is selected, just ignore the move
                thread_id = self.get_active_thread()
                if not thread_id:
                    return

                pos = event.pos()
                c = editor_widget.cursorForPosition(pos)

                filepath = os.path.abspath(self.editor.get_editor_path())
                if filepath not in self.sym_finder:
                    finder = debugger_plugin.core.symbols.SymbolFinder(open(filepath).read())
                    finder.parse()
                    self.sym_finder[filepath] = finder
                else:
                    finder = self.sym_finder[filepath]

                sym = finder.get(c.blockNumber()+1, c.columnNumber())
                if sym is not None:
                    ret = self.debugger_adapter.evaluate(thread_id,
                                                         sym.expression,
                                                         depth=0)

                    content = "{exp} = ({type}) {value}".format(
                                    exp=sym.expression, type=ret['type'],
                                    value=ret['value'])
                    QToolTip.showText(editor_widget.mapToGlobal(pos), content)


            finally:
                self.__old_mouse_event(event)
        # Install new event handler
        editor_widget.mouseMoveEvent = custom_mouse_movement

        print editor_widget.mouseMoveEvent

    def __uninstall_mouse_handler(self):
        """
        Removes the custom mouse event handler from the ninja-ide. Restores
        the mouse event handler to its previous state.
        """
        self.editor.get_editor().mouseMoveEvent = self.__old_mouse_event

    #
    # Events management
    #

    def process_event(self, event):
        """Method to process events from the EventWatcher."""
        print repr(event)
        self.logger.debug("Processing event: ({0})".format(repr(event)))

        if event['type'] == 'THREAD_CREATE':
            # New thread
            tid = event['id']
            item = debugger_plugin.core.models.ThreadModel(tid, event['name'], debugger_plugin.core.models.ThreadModel.RUNNING)
            self.threads_model.add(tid, item)
            self.threadsView.update(expand=True)

        if event['type'] == 'THREAD_PAUSE':
            tid = event['id']
            tfile = event['file']
            tline = event['line']
            tobj = self.threads_model.get(tid)
            tobj.state = debugger_plugin.core.models.ThreadModel.PAUSED
            st_trace = debugger_plugin.core.models.ThreadStackEntry(tfile, tline)
            tobj.epointer = st_trace
            self.threadsView.update(tobj, True)
            # Update threads
            self.select_thread()

        if event['type'] == 'THREAD_STOP':
            # Thread died
            tid = event['id']
            if self.threads_model.get(tid):
                self.threads_model.remove(tid)
            self.threadsView.update(expand=True)

        if event['type'] == 'THREAD_RESUME':
            # Thread resumed
            tid = event['id']
            tobj = self.threads_model.get(tid)
            tobj.state = debugger_plugin.core.models.ThreadModel.RUNNING
            self.threadsView.update(tobj, True)

        #if event['type'] == 'DEBUG_START':
        #    pass

        if event['type'] == 'DEBUG_END':
            self.debugger_adapter.stop()
            # Wait half second before kill the process
            time.sleep(0.5)
            self.debug_stop()

    #
    # Threads management
    #

    def get_active_thread(self):
        """
        Return the currently selected thread in threadview.
        """
        thread_id = None
        selected = (self.threadsView and self.threadsView.selectedItems()) or None
        if selected:
            item = selected.pop()

            if isinstance(item.data, debugger_plugin.core.models.ThreadModel):
                thread_id = item.data.ident
        return thread_id

    #
    # Debugger commands
    #

    def debug_cont(self):
        """Sends a command to the debugger to execute a continue."""
        # Check if we have selected a thread in the ThreadsView and
        # resume only that thread.
        thread_id = self.get_active_thread()

        # Resume just the selected thread. If thread_id is None, then all
        # threads are resumed.
        if thread_id:
            self.debugger_adapter.resume(thread_id)
        else:
            self.debugger_adapter.resume_all()

    def debug_stop(self):
        """Stops the debugger and ends the debugging session."""
        self.ide.actions.kill_execution()
        self._activate_debug_actions(False)
        self._deactivate_ui()

    def debug_over(self):
        """Sends a command to the debugger to execute a step over."""
        thread_id = self.get_active_thread()
        if thread_id:
            # Step just the selected thread
            self.debugger_adapter.step_over(thread_id)

    def debug_into(self):
        """Sends a command to the debugger to execute a step into."""
        thread_id = self.get_active_thread()
        if thread_id:
            # Step just the selected thread
            self.debugger_adapter.step_into(thread_id)

    def debug_out(self):
        """Sends a command to the debugger to execute a step out."""
        thread_id = self.get_active_thread()
        if thread_id:
            # Step just the selected thread
            self.debugger_adapter.step_out(thread_id)

    def reevaluate_watch(self, watch):
        """Evaluate the watch in the context of the selected thread."""
        thread_id = self.get_active_thread()
        watch.value = '<Cannot evaluate>'
        if thread_id:
            # Evaluate watch
            ret = self.debugger_adapter.evaluate(thread_id,
                                                 watch.expression,
                                                 depth=0)
            watch.type = ret['type']
            watch.value = ret['value']


class EventWatcher(QThread):
    """
    An object of this class allows to monitor a DebuggerSlave. The object will
    poll continuously for events thru the DebuggerMaster. If an event appears a
    signal will be triggered.
    """
    newEvent = pyqtSignal(dict, name="newEvent(PyQt_PyObject)")

    def __init__(self, get_messages_fn):
        """Initializes the EventWatcher."""
        QThread.__init__(self)
        self.__state = "stopped"
        self.fn = get_messages_fn
        self.logger = logging.getLogger(__name__)

    def run(self):
        """
        Starts the cycle of checking for events from the debugger. Every time
        a new event is found, the newEvent signal is emitted.
        """
        try:
            self.logger.info("Starting event watcher")
            self.__state = "running"
            while self.__state == "running":
                # If the next call raises an exception, do I really want to go on?
                events = self.fn()
                for e in events:
                    self.logger.debug("New Event: {0}".format(repr(e)))
                    self.newEvent.emit(e)
                time.sleep(0.1)
        except:
            pass
        # Done with the loop
        self.__state = "stopped"

    def quit(self):
        """Ends the cycle of polling the debugger for events."""
        self.logger.info("Stopping event watcher")
        self.__state = "stopping"
