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
## Instala los iconos en el sistema de forma global

############################
##       FUNCIONES        ##
############################
instalar_iconos() {
    echo -e "$VE Instalando iconos personalizados dentro de$RO /usr/share/icons/fryntiz$CL"
    if [[ -d '/usr/share/icons/fryntiz' ]]; then
        sudo rm -Rf '/usr/share/icons/fryntiz'
    fi
    sudo cp -r "$WORKSCRIPT/conf/usr/share/icons/fryntiz" '/usr/share/icons/fryntiz'
    sudo chmod 755 -R '/usr/share/icons/fryntiz'

    iconos_paper_theme() {
        echo -e "$VE Descargando pack de iconos$RO Paper Theme$CL"
        descargar 'Paper_Theme.deb' 'https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-gtk-theme,16.04'

        echo -e "$VE Instalando iconos$RO Paper_Theme$CL"
        instalarSoftwareDPKG "$WORKSCRIPT/tmp/Paper_Theme.deb"
    }

    iconos_paper_theme

    ## Establece iconos Paper en uso
    gconftool-2 --type string --set /desktop/gnome/interface/icon_theme 'Paper'

    ## Lo enlazo para que se usen por defecto con el usuario
    if [[ -d "$HOME/.local/share/icons/default" ]]; then
        rm -Rf "$HOME/.local/share/icons/default"
    fi

    mkdir -p "$HOME/.local/share/icons/default"

    if [[ -d '/usr/share/icons/Paper' ]]; then
        ln -s '/usr/share/icons/Paper/index.theme' "$HOME/.local/share/icons/default/index.theme"
    fi
}
