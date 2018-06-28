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
## Configura terminales

############################
##       FUNCIONES        ##
############################

terminales_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO terminales$CL"
    instalarSoftware 'dconf-cli'
}

terminales_instalar() {
    echo -e "$VE Preparando para instalar$RO terminales$CL"
    instalarSoftware tilix terminator
}

terminales_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO terminales$CL"

    ## Crear backup: dconf dump /com/gexperts/Tilix/ > ~/Debian_Developer_Init/conf/tilix.conf
    echo -e "$VE Generando configuración para$RO Tilix$CL"
    dconf load /com/gexperts/Tilix/ < "$WORKSCRIPT/conf/Apps/Tilix/tilix.conf"

    if [[ ! -f "/etc/profile.d/vte.sh" ]]; then
        sudo cp "$WORKSCRIPT/conf/Apps/Tilix/vte.sh" "/etc/profile.d/vte.sh"
        sudo chmod 744 "/etc/profile.d/vte.sh"
        sudo chown root:root "/etc/profile.d/vte.sh"
    fi

    if [[ ! -f "/etc/profile.d/vte-2.91.sh" ]]; then
        sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
        sudo chmod 744 "/etc/profile.d/vte-2.91.sh.sh"
        sudo chown root:root "/etc/profile.d/vte-2.91.sh.sh"
    fi

    enlazarHome '.config/tilix' '.config/terminator'

    ## Defino terminal tilix por defecto
    gsettings set org.gnome.desktop.default-applications.terminal 'exec' "tilix"

    if [[ -f /usr/bin/tilix ]]; then
        echo -e "$VE Estableciendo terminal por defecto a$RO Tilix$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper
    elif [[ -f '/usr/bin/terminator' ]]; then
        echo -e "$VE Estableciendo terminal por defecto a$RO Terminator$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/terminator
    elif [[ -f '/usr/bin/sakura' ]]; then
        echo -e "$VE Estableciendo terminal por defecto a$RO Sakura$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/sakura
    else
        echo -e "$VE Estableciendo terminal por defecto a$RO XTerm$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/xterm
    fi
}

terminales_instalador() {
    echo -e "$VE Comenzando instalación de$RO terminales$CL"

    terminales_preconfiguracion
    terminales_instalar
    terminales_postconfiguracion
}
