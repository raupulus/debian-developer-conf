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
## Menú principal para configurar al usuario

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Usuario/gedit.sh"
source "$WORKSCRIPT/Usuario/nano.sh"
source "$WORKSCRIPT/Usuario/permisos.sh"
source "$WORKSCRIPT/Usuario/plantillas.sh"
source "$WORKSCRIPT/Usuario/programas-default.sh"
source "$WORKSCRIPT/Usuario/terminales.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú instalar todas las configuraciones del usuario
##
menuUsuario() {
    usuario_permisos
    usuario_programas_default

    cd "$WORKSCRIPT"

    usuario_gedit
    usuario_nano
    usuario_plantillas
    usuario_terminales
}
