#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        www.fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
## Menú principal para configurar al Root Root

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Root/nano.sh"
source "$WORKSCRIPT/Root/permisos.sh"
source "$WORKSCRIPT/Root/programas-default.sh"
source "$WORKSCRIPT/Root/terminales.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú instalar todas las configuraciones del Root
##
menuRoot() {
    echo -e "$RO No implementado$CL"
    echo -e "$RO Simulando scripts (no es real esta parte)$CL"

    root_permisos
    root_programas_default

    cd "$WORKSCRIPT"

    root_nano
    root_terminales
}
