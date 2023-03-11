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
