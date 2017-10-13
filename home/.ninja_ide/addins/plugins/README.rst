=====
Ninja Django Plugin.
=====
A help for Djangoers using Ninja Ide (work in progress)
--------

This plugin is yet fairly simple.

What we have right now is the following:

- Support for Django syntax (we actually built this into html syntax in ninja until the IDE can provide a suitable syntax system that allows us to modify the syntax of any file type to include template items.)
- Template Preview: You can render the templates using custom values modifiable via gui
- Django Project Type: You can create a "Django App" project type that will be used to identify the files that can be templates and in a future all the files that can be affected by all the plugin features.

**WARNING:** *In order to use this plugin you do need to have a working django instance WITH virtualenv and it must be working.*

For the rest, have some Copyright Notice :
::
  This file is part of NINJA-DJANGO-PLUGIN
  (https://github.com/machinalis/ninja-django-plugin.)
  
  Copyright (C) 2012 Machinalis S.R.L <http://www.machinalis.com>
  
  Authors: Daniel Moisset <dmoisset at machinalis dot com>
           Horacio Duran <hduran at machinalis dot com>

  NINJA-DJANGO-PLUGIN is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 3 of the License, or
  any later version.

  NINJA-DJANGO-PLUGIN  is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with NINJA-DJANGO-PLUGIN; If not, see <http://www.gnu.org/licenses/>.
