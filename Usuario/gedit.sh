#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

##
## Configurar editor de gnome, gedit
##
usuario_gedit() {
    echo -e "$VE Configurando$RO Gedit$CL"
    local WORKDIR_GEDIT="$WORKSCRIPT/conf/Apps/gedit"

    if [[ ! -d "$HOME/.local/share" ]]; then
        mkdir -p "$HOME/.local/share/"
    fi
    cp -r $WORKDIR_GEDIT/.local/share/* "$HOME/.local/share/"

    if [[ ! -d "$HOME/.config/gedit/" ]]; then
        mkdir -p "$HOME/.config/gedit/"
    fi
    cp -r $WORKDIR_GEDIT/.config/gedit/* "$HOME/.config/gedit/"
}
