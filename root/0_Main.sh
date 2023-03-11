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
## Menú principal para configurar al Root Root

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/root/nano.sh"
source "$WORKSCRIPT/root/permisos.sh"
source "$WORKSCRIPT/root/programas-default.sh"
source "$WORKSCRIPT/root/terminales.sh"
source "$WORKSCRIPT/root/vim.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú instalar todas las configuraciones del Root
##
menu_root() {
    echo -e "$RO No implementado$CL"
    echo -e "$RO Simulando scripts (no es real esta parte)$CL"

    root_permisos
    root_programas_default

    cd "$WORKSCRIPT"

    root_nano
    root_vim
    root_terminales
}
