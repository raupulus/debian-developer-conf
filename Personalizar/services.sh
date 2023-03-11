#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2020 Raúl Caro Pastorino
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
## Habilita y/o deshabilita servicios

############################
##       FUNCIONES        ##
############################

services_enable_disable() {
    echo -e "$VE Habilitando servicios al iniciar$CL"

    echo -e "$VE Deshabilitando servicios al iniciar$CL"

    ## TODO → Buscar cómo gestionar en macos y crear función global en functions.sh

    if [[ "${DISTRO}" = 'macos' ]]; then
        echo -e "$RO IMPLEMENTAR SERVICIOS PARA MACOS$CL"
    else
        sudo systemctl disable apt-daily.timer
        sudo systemctl stop apt-daily.timer

        sudo systemctl disable apt-daily-upgrade.timer
        sudo systemctl stop apt-daily-upgrade.timer

        sudo systemctl disable unattended-upgrades.service
        sudo systemctl stop unattended-upgrades.service
    fi
}
