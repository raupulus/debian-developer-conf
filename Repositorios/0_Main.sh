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
## @twitter    https://twitter.com/raupulus
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
