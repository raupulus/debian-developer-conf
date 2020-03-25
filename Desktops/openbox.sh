#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/bash-guide-style

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
    instalarSoftwareLista "$SOFTLIST/Desktops/x11-base.lst"
}

openbox_instalar() {
    echo -e "$VE Preparando para instalar$RO openbox$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/openbox.lst"
}

##
## Instalando software extra y configuraciones adicionales
##
openbox_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO openbox$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/wm-min-software.lst"
}

openbox_instalador() {
    echo -e "$VE Comenzando instalación de$RO openbox$CL"

    openbox_preconfiguracion
    openbox_instalar
    openbox_postconfiguracion
}
