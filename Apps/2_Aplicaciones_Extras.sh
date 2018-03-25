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
## Este script enlaza la instalación de todas las aplicaciones opcionales
## que podían ser interesante instalar en uno u otro momento.
##
## ¡Actualmente se instala todo por defecto!
## TODO → Admitir parámetro $1 = -a para instalar todo
## TODO → Mostrar opciones para instalar 1 programa concreto con las opciones:
##        - Instalar
##        - Reinstalar
##        - Volver a descargar y luego reinstalar

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Apps/bashit.sh"
source "$WORKSCRIPT/Apps/DBeaver.sh"
source "$WORKSCRIPT/Apps/GitKraken.sh"
source "$WORKSCRIPT/Apps/Haroopad.sh"
source "$WORKSCRIPT/Apps/i3wm.sh"
source "$WORKSCRIPT/Apps/OhMyZsh.sh"
source "$WORKSCRIPT/Apps/Pencil-Project.sh"
source "$WORKSCRIPT/Apps/vim.sh"

############################
##       FUNCIONES        ##
############################
aplicaciones_extras() {
    echo -e "$VE Instalando Aplicaciones$RO Extras$CL"
    dbeaver_instalador
    gitkraken_instalador
    haroopad_instalador
    pencilProject_instalador
    vim_Instalador
    bashit_Instalador
    ohmyzsh_Instalador
}
