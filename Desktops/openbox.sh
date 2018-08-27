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
## Plantea la instalación de Openbox con las configuraciones

############################
##       FUNCIONES        ##
############################
openbox_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO openbox$CL"
    enlazarHome '.idesktop' '.config/.openbox' '.ideskrc'
}

openbox_instalar() {
    echo -e "$VE Preparando para instalar$RO openbox$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/openbox.lst"
    instalarSoftwareLista "$SOFTLIST/Desktops/wm-min-software.lst"
}

##
## Instalando software extra y configuraciones adicionales
##
openbox_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO openbox$CL"
}

openbox_instalador() {
    echo -e "$VE Comenzando instalación de$RO openbox$CL"

    openbox_preconfiguracion
    openbox_instalar
    openbox_postconfiguracion
}
