#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

###########################
##       FUNCTIONS       ##
###########################

configurations_crons() {
    echo -e "$VE Instalando tareas$RO Cron$CL"

    if [[ "${DISTRO}" = 'macos' ]]; then
        echo "Tareas cron para mac aún no planteadas"
    else
        sudo cp "${WORKSCRIPT}/conf/etc/cron.d/*" '/etc/cron.d'
        sudo chmod 644 -R /etc/cron.d/*
    fi
}
