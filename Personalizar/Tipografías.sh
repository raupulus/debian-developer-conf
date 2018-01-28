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
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################
agregar_fuentes() {
    echo -e "$VEAñadiendo$RO fuentes Tipográficas$VE al sistema$CL"

    fuentes_repositorios="fonts-powerline fonts-freefont-ttf fonts-hack-ttf fonts-lmodern"

    for f in "$fuentes_repositorios"; do
        echo -e "$VE Instalando fuente$MA →$RO $f $CL"
        instalarSoftware "$f"
    done

    for f in "$WORKSCRIPT/fonts/*"
    do
        if [[ -d "$WORKSCRIPT/fonts/$f" ]]; then
            echo -e "$VE Instalando fuente$MA →$RO $f $CL"
            sudo cp -r "$HOME/fonts/$f/" '/usr/local/share/fonts/'
        fi
    done
}
