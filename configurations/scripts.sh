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

configurations_scripts() {
    echo -e "$VE Añadiendo scripts a$RO /bin$CL"

    addScriptToBin '??????'

    if [[ "${MY_DISTRO}" = 'raspbian' ]]; then
        echo -e "$VE Añadiendo scripts de raspbian a$RO /bin$CL"
    fi
}
