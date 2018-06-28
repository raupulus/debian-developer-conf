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
fuentes_repositorios() {
    echo -e "$VE Instalando fuentes desde$RO repositorios$CL"

    fuentes_repositorios="fonts-powerline fonts-freefont-ttf fonts-hack
    fonts-hack-ttf fonts-lmodern fonts-font-awesome fonts-inconsolata
    fonts-dejavu fonts-dejavu-extra fonts-linuxlibertine xfonts-terminus
    fonts-fantasque-sans fonts-firacode fonts-jura fonts-liberation
    fonts-liberation2 fonts-cantarell fonts-lobster"

    for f in $fuentes_repositorios; do
        echo -e "$VE Instalando fuente$MA →$RO $f $CL"
        instalarSoftware "$f"
    done
}

fuentes_download() {
    descargar 'Inconsolata Nerd Font Complete.otf' 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Inconsolata/complete/Inconsolata%20Nerd%20Font%20Complete.otf'

    descargar 'Inconsolata Nerd Font Complete Mono.otf' 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Inconsolata/complete/Inconsolata%20Nerd%20Font%20Complete%20Mono.otf'

    descargar 'Inconsolata-dz for Powerline.otf' 'https://github.com/powerline/fonts/blob/master/InconsolataDz/Inconsolata-dz%20for%20Powerline.otf'

    if [[ ! -d '/usr/share/fonts/Inconsolata' ]]; then
        sudo mkdir '/usr/share/fonts/Inconsolata'
    fi

    sudo cp "$WORKSCRIPT/tmp/Inconsolata Nerd Font Complete.otf" '/usr/share/fonts/Inconsolata/'

    sudo cp "$WORKSCRIPT/tmp/Inconsolata Nerd Font Complete Mono.otf" '/usr/share/fonts/Inconsolata/'

    sudo chmod 755 -R '/usr/share/fonts/Inconsolata'

    if [[ ! -d '/usr/share/fonts/Powerline' ]]; then
        sudo mkdir '/usr/share/fonts/Powerline'
    fi

    sudo cp "$WORKSCRIPT/tmp/Inconsolata-dz for Powerline.otf" '/usr/share/fonts/Powerline/'

    sudo chmod 755 -R '/usr/share/fonts/Powerline'
}

fuentes_nerdfonts() {
    instaladas=False
    if [[ -d "$WORKSCRIPT/tmp/nerd-fonts" ]]; then
        cd "$WORKSCRIPT/tmp/nerd-fonts" || exit
        git checkout -- .
        git pull
        instaladas=True
    else
        git clone --depth 1 'https://github.com/ryanoasis/nerd-fonts.git' "$WORKSCRIPT/tmp/nerd-fonts"
    fi

    if [[ $instaladas = True ]]; then
        echo -e "$VE Las fuentes$RO Nerd-Fonts$VE ya estaban instaladas, reinstalar?$CL"
        read -p ' s/N → ' SN

        if [[ "$SN" = 'y' ]] ||
           [[ "$SN" = 'Y' ]] ||
           [[ "$SN" = 's' ]] ||
           [[ "$SN" = 'S' ]]
        then
            cd "$WORKSCRIPT/tmp/nerd-fonts" || exit
            ./install.sh
            cd "$WORKSCRIPT" || exit
        fi
    else
        cd "$WORKSCRIPT/tmp/nerd-fonts" || exit
        ./install.sh
        cd "$WORKSCRIPT" || exit
    fi
}

fuentes_locales() {
    for f in $WORKSCRIPT/fonts/*
    do
        if [[ -d "$WORKSCRIPT/fonts/$f" ]]; then
            echo -e "$VE Instalando fuente$MA →$RO $f $CL"
            sudo cp -r "$HOME/fonts/$f/" '/usr/local/share/fonts/'
        fi
    done
}

agregar_fuentes() {
    echo -e "$VE Añadiendo$RO fuentes Tipográficas$VE al sistema$CL"

    fuentes_repositorios
    fuentes_download
    fuentes_locales

    if [[ -d "$WORKSCRIPT/tmp/nerd-fonts/.git" ]]; then
        fuentes_nerdfonts
    else
        echo -e "$VE ¿Instalar$RO Nerd-Fonts$VE, ocupará más de 1GB (y su descarga)?"
        read -p ' s/N → ' SN

        if [[ "$SN" = 'y' ]] ||
           [[ "$SN" = 'Y' ]] ||
           [[ "$SN" = 's' ]] ||
           [[ "$SN" = 'S' ]]
        then
            fuentes_nerdfonts
        fi
    fi
}
