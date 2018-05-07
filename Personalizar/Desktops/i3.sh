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
## Plantea la instalación de i3wm con las configuraciones

############################
##       FUNCIONES        ##
############################
i3wm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO i3wm$CL"
}

i3wm_instalar() {
    echo -e "$VE Preparando para instalar$RO i3wm$CL"
    instalarSoftware i3-wm i3-blocks suckless-tools
}

##
## Instalando software extra y configuraciones adicionales
##
i3wm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO i3wm$CL"

    echo -e "$VE Instalando software secundario$CL"
    instalarSoftware rxvt-unicode-256color compton compton-conf compton-conf-l10n nitrogen gpicview thunar ranger w3m tint2 arandr neofetch

    echo -e "$VE Generando archivos de configuración$CL"
    ## Enlazar "$WORKSCRIPT/conf/home/.i3" en "$HOME/.i3"
    enlazarHome '.config/i3' '.conf/tint2' '.conf/compto.conf' '.conf/conky' '.Xresources' '.config/nitrogen'
}

i3wm_instalador() {
    echo -e "$VE Comenzando instalación de$RO i3wm$CL"

    i3wm_preconfiguracion
    i3wm_instalar
    i3wm_postconfiguracion
}

##
## Instalador para el fork de i3 gaps en:
## https://github.com/Airblader/i3/tree/gaps
## Se usa la rama "gaps" en vez de la rama "gaps-next"
##
i3wm_gaps_instalador() {
    ## Instalando dependencias
    instalarSoftware libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev

    ## Instalo i3gaps desde repositorio GitHub en vez de i3 normal
    git clone https://www.github.com/Airblader/i3 i3-gaps
    cd i3-gaps || exit
    git checkout gaps && git pull

    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build || exit

    ./configure
    cd x86_64-pc-linux-gnu && make && sudo make install
}
