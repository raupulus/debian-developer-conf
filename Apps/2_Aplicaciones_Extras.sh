#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        www.fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/apps/Atom_IDE.sh"
source "$WORKSCRIPT/apps/bashit.sh"
source "$WORKSCRIPT/apps/Brackets.sh"
source "$WORKSCRIPT/apps/DBeaver.sh"
source "$WORKSCRIPT/apps/GitKraken.sh"
source "$WORKSCRIPT/apps/Haroopad.sh"
source "$WORKSCRIPT/apps/i3wm.sh"
source "$WORKSCRIPT/apps/Ninja-IDE.sh"
source "$WORKSCRIPT/apps/Pencil-Project.sh"
source "$WORKSCRIPT/apps/vim.sh"

############################
##       CONSTANTES       ##
############################

###########################
##       VARIABLES       ##
###########################

###########################
##       FUNCIONES       ##
###########################
aplicaciones_extras() {
    echo -e "$VE Instalando Aplicaciones Extras$CL"
    atom_instalador
    brackets_instalador
    dbeaver_instalador
    gitkraken_instalador
    haroopad_instalador
    ninjaide_instalador
    pencilProject_instalador
    vim_Instalador
    bashit_Instalador
}

###########################
##       EJECUCIÓN       ##
###########################
