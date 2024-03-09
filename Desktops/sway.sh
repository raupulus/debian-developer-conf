#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2020 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Plantea la instalación de Sway con las configuraciones

############################
##       FUNCIONES        ##
############################
sway_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO sway$CL"
}

sway_instalar() {
    echo -e "$VE Preparando para instalar$RO sway$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/sway.lst"
}

##
## Instalando software extra y configuraciones adicionales
##
sway_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO sway$CL"

    echo -e "$VE Instalando software secundario$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/wayland-base.lst"
    instalarSoftwareLista "$SOFTLIST/Desktops/wm-min-software-wayland.lst"

    echo -e "$VE Generando archivos de configuración$CL"
    enlazarHome '.config/sway' '.config/i3pystatus' '.scripts' '.Xresources' '.config/wofi' '.config/swaylock'

    ## Instalo y Configuro Python: Lenguajes-Programacion/python.sh
    python_instalador

    ## Dependencias para i3pystatus con python.
    python3Install 'basiciw' 'netifaces' 'colour' \
    'pyalsaaudio' 'fontawesome'
}

sway_postconfiguracionOpcional() {
    echo -e "$VE Generando Post-Configuraciones Opcionales$RO sway$CL"
}

sway_instalador() {
    echo -e "$VE Comenzando instalación de$RO sway$CL"

    sway_preconfiguracion
    sway_instalar
    sway_postconfiguracion
    sway_postconfiguracionOpcional

    ## Configurando Personalizaciones
    conf_gtk2  ## Configura gtk-2.0 desde script → Personalizacion_GTK
    conf_gtk3  ## Configura gtk-3.0 desde script → Personalizacion_GTK
    conf_gtk4  ## Configura gtk-4.0 desde script → Personalizacion_GTK
}
