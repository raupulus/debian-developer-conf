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
## Instala todas las fuentes tiporáficas del directorio "fonts" en la raíz de
## este repositorio a nuestro sistema de forma global y accesible para todos
## los usuarios.
##
## También instala algunas fuentes desde repositorios oficiales de la
## distribución Debian.

############################
##       FUNCIONES        ##
############################
agregar_fuentes() {
    echo -e "$VEAñadiendo$RO fuentes Tipográficas$VE al sistema$CL"

    fuentes_repositorios="fonts-powerline fonts-freefont-ttf fonts-hack-ttf fonts-lmodern"

    for f in $fuentes_repositorios; do
        echo -e "$VE Instalando fuente$MA →$RO $f $CL"
        instalarSoftware "$f"
    done

    for f in $WORKSCRIPT/fonts/*
    do
        if [[ -d "$WORKSCRIPT/fonts/$f" ]]; then
            echo -e "$VE Instalando fuente$MA →$RO $f $CL"
            sudo cp -r "$HOME/fonts/$f/" '/usr/local/share/fonts/'
        fi
    done

    nerd_fonts() {
        if [[ -d "$WORKSCRIPT/tmp/nerd-fonts" ]]; then
            cd "$WORKSCRIPT/tmp/nerd-fonts" || exit
            git checkout -- .
            git pull
        else
            git clone --depth 1 'https://github.com/ryanoasis/nerd-fonts.git' "$WORKSCRIPT/tmp/nerd-fonts"
        fi

        cd "$WORKSCRIPT/tmp/nerd-fonts" || exit
        ./install.sh
        cd "$WORKSCRIPT" || exit
    }

    if [[ -d "$WORKSCRIPT/tmp/nerd-fonts/.git" ]]; then
        nerd_fonts
    else
        echo -e "$VE ¿Instalar$RO Nerd-Fonts$VE, ocupará más de 1GB (y su descarga)?"
        read -p ' s/N → ' SN

        if [[ "$SN" = 'y' ]] ||
           [[ "$SN" = 'Y' ]] ||
           [[ "$SN" = 's' ]] ||
           [[ "$SN" = 'S' ]]
        then
            nerd_fonts
        fi
    fi
}
