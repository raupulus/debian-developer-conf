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

############################
##       CONSTANTES       ##
############################
AM="\033[1;33m"  ## Color AM
AZ="\033[1;34m"  ## Color Azul
BL="\033[1;37m"  ## Color Blanco
CY="\033[1;36m"  ## Color Cyan
GR="\033[0;37m"  ## Color CL
MA="\033[1;35m"  ## Color Magenta
RO="\033[1;31m"  ## Color RO
VE="\033[1;32m"  ## Color VE
CL="\e[0m"       ## Limpiar colores

#############################
##   Variables Generales   ##
#############################

############################
##     IMPORTACIONES      ##
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
