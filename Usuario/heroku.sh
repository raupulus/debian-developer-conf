#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
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
