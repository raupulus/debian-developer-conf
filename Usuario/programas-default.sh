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

##
## Establecer programas por defecto
##
usuario_programas_default() {
    echo -e "$VE Estableciendo programas por defecto$CL"
    ## Navegador
    if [[ -f '/usr/bin/firefox-esr' ]]; then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Firefox-ESR$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/firefox-esr
        sudo update-alternatives --set gnome-www-browser /user/bin/firefox-esr 2>> /dev/null
    elif [[ -f '/usr/bin/firefox' ]]; then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Firefox$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/firefox
        sudo update-alternatives --set gnome-www-browser /user/bin/firefox 2>> /dev/null
    elif [[ -f '/usr/bin/chromium' ]]; then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Chromium$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/chromium
        sudo update-alternatives --set gnome-www-browser /user/bin/chromium 2>> /dev/null
    elif [[ -f '/usr/bin/chrome' ]]; then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO chrome$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/chrome
        sudo update-alternatives --set gnome-www-browser /user/bin/chrome 2>> /dev/null
    fi

    ## Editor de texto terminal
    if [[ -f '/usr/bin/vim' ]]; then
        echo -e "$VE Estableciendo Editor WEB por defecto a$RO Vim$CL"
        sudo update-alternatives --set editor /usr/bin/vim.basic
    elif [[ -f '/bin/nano' ]]; then
        echo -e "$VE Estableciendo Editor WEB por defecto a$RO Nano$CL"
        sudo update-alternatives --set editor /bin/nano
    fi

    ## Editor de texto con GUI
    if [[ -f '/usr/bin/geany' ]]; then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Geany$CL"
        sudo update-alternatives --install /usr/bin/gnome-text-editor gnome-text-editor /usr/bin/geany 10
        sudo update-alternatives --set gnome-text-editor /usr/bin/geany
    elif [[ -f '/usr/bin/gedit' ]]; then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Gedit$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/gedit
    elif [[ -f '/usr/bin/kate' ]]; then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Kate$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/kate
    elif [[ -f '/usr/bin/leafpad' ]]; then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Leafpad$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/leafpad
    fi
}
