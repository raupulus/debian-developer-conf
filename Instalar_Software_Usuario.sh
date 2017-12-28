#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

############################
##   Constantes Colores   ##
############################
amarillo="\033[1;33m"
azul="\033[1;34m"
blanco="\033[1;37m"
cyan="\033[1;36m"
gris="\033[0;37m"
magenta="\033[1;35m"
rojo="\033[1;31m"
verde="\033[1;32m"

#############################
##   Variables Generales   ##
#############################
# Añadir entrada al menú principal para separar aplicaciones que solo se
# instalan por usuario y no en general.
# - Configuración de Atom
# - Navegadores Firefox developer
# - ¿Bashit?
# - ¿psysh? → Probablemente sea mejor mover a global /opt

source Apps/Firefox.sh

configurar_heroku() {
    echo "Se va a configurar Heroku"
    heroku login
}

function instalar_Software_Usuario() {
    echo -e "$verde Preparando para instalar aplicaciones para el usuario"
    firefox_install
    configurar_heroku
}
