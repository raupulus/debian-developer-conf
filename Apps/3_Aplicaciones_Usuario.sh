#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        www.fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Apps/Firefox.sh"

############################
##       CONSTANTES       ##
############################

###########################
##       VARIABLES       ##
###########################

###########################
##       FUNCIONES       ##
###########################
configurar_heroku() {
    echo -e "$VE Se va a configurar$RO Heroku$CL"
    instalarSoftware 'heroku'
    echo -e "$VE ¿Quieres configurar tu cuenta de$RO Heroku?$CL"
    echo -e "$VE Para configurar la cuenta tienes que tenerla creada$CL"
    read -p '    s/N → ' input
    if [[ $input = 's' ]] || [[ $input = 'S' ]]; then
        heroku login
    fi
}

aplicaciones_usuarios() {
    echo -e "$VE Instalando Aplicaciones específicas para el usuario$RO $USER$CL"
    configurar_heroku
    firefox_instalador
}

###########################
##       EJECUCIÓN       ##
###########################
