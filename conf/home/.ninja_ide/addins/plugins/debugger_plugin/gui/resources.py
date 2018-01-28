#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Module to centralize the definition of settings and UI resources.
'''

import os

ICONS_PATH = os.path.join(os.path.abspath(os.path.dirname(__file__)), 'icons')

# Toolbars
RES_ICON_START = os.path.join(ICONS_PATH, 'btn_start.png')
RES_ICON_CONT = os.path.join(ICONS_PATH, 'btn_cont.png')
RES_ICON_STOP = os.path.join(ICONS_PATH, 'btn_stop.png')
RES_ICON_INTO = os.path.join(ICONS_PATH, 'btn_into.png')
RES_ICON_OVER = os.path.join(ICONS_PATH, 'btn_over.png')
RES_ICON_OUT = os.path.join(ICONS_PATH, 'btn_out.png')

# Watches widget
RES_ICON_WATCH_ITEM = os.path.join(ICONS_PATH, 'watch_item.png')

# Thread widget
RES_ICON_THREAD_GROUP = os.path.join(ICONS_PATH, 'thread_group.png')
RES_ICON_THREAD_ITEM_PAUSE = os.path.join(ICONS_PATH, 'thread_item_paused.png')
RES_ICON_THREAD_ITEM_RUN = os.path.join(ICONS_PATH, 'thread_item_run.png')

RES_STR_DEBUG_PROJECT_START = 'Debug Main Project'
RES_STR_DEBUG_FILE_START = 'Debug Current File'
RES_STR_DEBUG_STOP = 'Stop'
RES_STR_DEBUG_CONTINUE = 'Continue'
RES_STR_DEBUG_STEPINTO = 'Step Into'
RES_STR_DEBUG_STEPOVER = 'Step Over'
RES_STR_DEBUG_STEPOUT = 'Step Out'
