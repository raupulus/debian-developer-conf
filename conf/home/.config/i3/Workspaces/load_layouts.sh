#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Carga los espacios de trabajo adjuntos en este mismo directorio en formato
## JSON conteniendo toda la información sobre el posicionamiento de cada
## programa.

############################
##       FUNCIONES        ##
############################

i3-msg "workspace 2:TERM; append_layout ~/.config/i3/Workspaces/workspace_2.json"
