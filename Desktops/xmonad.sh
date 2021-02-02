#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################
## Plantea la instalación de Xmonad con las configuraciones

############################
##       FUNCIONES        ##
############################
xmonad_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO xmonad$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/x11-base.lst"
}

xmonad_instalar() {
    echo -e "$VE Preparando para instalar$RO xmonad$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/xmonad.lst"
}

##
## Instalando software extra y configuraciones adicionales
##
xmonad_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO xmonad$CL"

    echo -e "$VE Instalando software secundario$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/wm-min-sogtware.lst"

    echo -e "$VE Generando archivos de configuración$CL"
    enlazarHome '.config/.xmonad'

    ## Compilar
    xmonad --recompile
}

xmonad_postconfiguracionOpcional() {
    echo -e "$VE Generando Post-Configuraciones Opcionales$RO xmonad$CL"

    ## Cambiar background
    #gconftool --type string --set /desktop/gnome/background/picture_filename "/path/to/your/image.png"

    ## Cambiar icono gnome reemplazando:
    #/usr/share/icons/icon-theme/16x16/places/start-here.png
}

xmonad_instalador() {
    echo -e "$VE Comenzando instalación de$RO xmonad$CL"

    xmonad_preconfiguracion
    xmonad_instalar
    xmonad_postconfiguracion
    xmonad_postconfiguracionOpcional
}
