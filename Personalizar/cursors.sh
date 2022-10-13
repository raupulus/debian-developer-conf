#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2020 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Instala cursores

############################
##       FUNCIONES        ##
############################

cursors_install_generic() {
    echo -e "$VE Configurando cursor$RO Crystalblue$VE por defecto$CL"

    update-alternatives --set x-cursor-theme /etc/X11/cursors/crystalblue.theme

    sudo update-alternatives --set x-cursor-theme /etc/X11/cursors/crystalblue.theme

    if [[ ! -d "$HOME/.icons" ]]; then
            mkdir "$HOME/.icons"
        fi

        ## Enlazo en el usuario hacia los iconos crystalblue
        if [[ ! -d "$HOME/.icons/default" ]] &&
           [[ -f '/etc/X11/cursors/crystalblue.theme' ]]
        then
            mkdir "$HOME/.icons/default"
            ln -s '/etc/X11/cursors/crystalblue.theme' "$HOME/.icons/default/index.theme"
        fi
}

cursors_install_macos() {
    echo -e "$VE Instalando $RO Cursores Macos$CL"
}

cursors_install() {
    echo -e "$VE Instalando $RO Cursores$CL"
    instalarSoftwareLista "$SOFTLIST/Personalizar/cursors.lst"

    if [[ "${DISTRO}" = 'macos' ]]; then
        cursors_install_macos
    else
        cursors_install_generic
    fi
}
