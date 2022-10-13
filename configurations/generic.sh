#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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
##

###########################
##       FUNCTIONS       ##
###########################

configuration_command_not_found() {
    echo -e "$VE Actualizando$RO Command not Found$CL"

    if [[ -f '/usr/sbin/update-command-not-found' ]]; then
        sudo update-command-not-found >> /dev/null 2>> /dev/null
    fi
}

configurations_generic() {
    configuration_command_not_found
}
