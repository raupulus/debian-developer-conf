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
source "$WORKSCRIPT/Apps/Atom_IDE.sh"
source "$WORKSCRIPT/Apps/bashit.sh"
source "$WORKSCRIPT/Apps/Brackets.sh"
source "$WORKSCRIPT/Apps/DBeaver.sh"
source "$WORKSCRIPT/Apps/GitKraken.sh"
source "$WORKSCRIPT/Apps/Haroopad.sh"
source "$WORKSCRIPT/Apps/i3wm.sh"
source "$WORKSCRIPT/Apps/Ninja-IDE.sh"
source "$WORKSCRIPT/Apps/OhMyZsh.sh"
source "$WORKSCRIPT/Apps/Pencil-Project.sh"
source "$WORKSCRIPT/Apps/vim.sh"

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
    echo -e "$VE Instalando Aplicaciones$RO Extras$CL"
    atom_instalador
    brackets_instalador
    dbeaver_instalador
    gitkraken_instalador
    haroopad_instalador
    ninjaide_instalador
    pencilProject_instalador
    vim_Instalador
    bashit_Instalador
    ohmyzsh_Instalador
}

###########################
##       EJECUCIÓN       ##
###########################
