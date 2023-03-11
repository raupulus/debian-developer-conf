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
## Configurar editor de terminal, nano
##
usuario_heroku() {
    echo -e "$VE Se va a configurar$RO Heroku$CL"
    instalarSoftware 'heroku'
    echo -e "$VE ¿Quieres configurar tu cuenta de$RO Heroku?$CL"
    echo -e "$VE Para configurar la cuenta tienes que tenerla creada$CL"
    read -p '    s/N → ' input
    if [[ $input = 's' ]] || [[ $input = 'S' ]]; then
        heroku login
    fi
}
