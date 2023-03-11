#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
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
fonts_repositories() {
    echo -e "$VE Instalando fuentes desde$RO repositorios$CL"

    instalarSoftwareLista "$SOFTLIST/Personalizar/fonts.lst"
}

fonts_download() {
    descargar 'Inconsolata Nerd Font Complete.otf' 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Inconsolata/complete/Inconsolata%20Nerd%20Font%20Complete.otf'

    descargar 'Inconsolata Nerd Font Complete Mono.otf' 'https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Inconsolata/complete/Inconsolata%20Nerd%20Font%20Complete%20Mono.otf'

    descargar 'Inconsolata-dz for Powerline.otf' 'https://github.com/powerline/fonts/blob/master/InconsolataDz/Inconsolata-dz%20for%20Powerline.otf'

    if [[ ! -d '/usr/share/fonts/Inconsolata' ]]; then
        sudo mkdir '/usr/share/fonts/Inconsolata'
    fi

    if [[ ! -f '/usr/share/fonts/Inconsolata/Complete.otf' ]]; then
        sudo cp "$WORKSCRIPT/tmp/Inconsolata Nerd Font Complete.otf" '/usr/share/fonts/Inconsolata/'
    fi

    if [[ ! -f '/usr/share/fonts/Inconsolata/Mono.otf' ]]; then
        sudo cp "$WORKSCRIPT/tmp/Inconsolata Nerd Font Complete Mono.otf" '/usr/share/fonts/Inconsolata/'
    fi

    sudo chmod ugo+r -R '/usr/share/fonts/Inconsolata'

    if [[ ! -d '/usr/share/fonts/Powerline' ]]; then
        sudo mkdir '/usr/share/fonts/Powerline'
    fi

    if [[ ! -f '/usr/share/fonts/Powerline/Inconsolata-dz for Powerline.otf' ]]; then
        sudo cp "$WORKSCRIPT/tmp/Inconsolata-dz for Powerline.otf" '/usr/share/fonts/Powerline/'
    fi


    sudo chmod 755 -R '/usr/share/fonts/Powerline'
}

fonts_locals() {
    for f in $WORKSCRIPT/fonts/*
    do
        if [[ -d "$WORKSCRIPT/fonts/$f" ]]; then
            echo -e "$VE Instalando fuente$MA →$RO $f $CL"
            sudo cp -r "$HOME/fonts/$f/" '/usr/local/share/fonts/'
        fi
    done
}

fonts_install() {
    echo -e "$VE Añadiendo$RO fuentes Tipográficas$VE al sistema$CL"

    if [[ "${DISTRO}" = 'macos' ]]; then
        fonts_repositories
    else
        fonts_repositories
        fonts_download
        fonts_locals
    fi
}
