#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Repositorios/debian.sh"
source "$WORKSCRIPT/Repositorios/fedora.sh"
source "$WORKSCRIPT/Repositorios/raspbian.sh"
source "$WORKSCRIPT/Repositorios/macos.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú para configurar e integrar repositorios.
## @param $1 -a Si recibe este parámetro lo hará de forma automática
##
menuRepositorios() {
    ## Quito repositorios de vscode
    if [[ -f '/etc/apt/sources.list.d/vscode.list' ]]; then
        sudo rm -f '/etc/apt/sources.list.d/vscode.list' 2> /dev/null
    fi

    ## Quito firma de vscode y la bloqueo.
    if [[ -f '/etc/apt/trusted.gpg.d/microsoft.gpg' ]]; then
        sudo rm -vf '/etc/apt/trusted.gpg.d/microsoft.gpg' 2> /dev/null
        sudo touch '/etc/apt/trusted.gpg.d/microsoft.gpg' 2> /dev/null
        sudo chattr +i '/etc/apt/trusted.gpg.d/microsoft.gpg' 2> /dev/null
        sudo lsattr '/etc/apt/trusted.gpg.d/microsoft.gpg' 2> /dev/null
    fi

    if [[ "$DISTRO" = 'debian' ]]; then
        agregarRepositoriosDebian
    elif [[ "$DISTRO" = 'raspbian' ]]; then
        agregarRepositoriosRaspbian
    elif [[ "$DISTRO" = 'fedora' ]]; then
        agregarRepositoriosFedora
    elif [[ "$DISTRO" = 'gentoo' ]]; then
        agregarRepositoriosGentoo
    elif [[ "$DISTRO" = 'macos' ]]; then
        agregarRepositoriosMacos
    fi
}
