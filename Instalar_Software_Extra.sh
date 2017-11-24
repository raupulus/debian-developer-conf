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

# Este script contiene aplicaciones que son opcionales como editores

source Apps/Atom_IDE.sh
source Apps/Ninja-IDE.sh
source Apps/Brackets.sh
source Apps/DBeaver.sh

function haroopad_install() {
    if [ -f /usr/bin/haroopad ]
    then
        echo -e "$verde Ya esta$rojo Haroopad$verde instalado en el equipo, omitiendo paso$gris"
    else
        REINTENTOS=3
        echo -e "$verde Descargando$rojo Haroopad$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm haroopad-v0.13.1-x64.deb 2>> /dev/null
            wget --show-progress https://bitbucket.org/rhiokim/haroopad-download/downloads/haroopad-v0.13.1-x64.deb && break
        done
        echo -e "$verde Preparando para instalar$rojo Haroopad$gris"
        sudo dpkg -i haroopad-v0.13.1-x64.deb && sudo apt install -f -y
    fi
}

function instalar_Software_Extra() {
    echo -e "$verde Preparando para instalar software Extra$gris"
    atom_instalador
    brackets_instalador
    dbeaver_instalador
    ninjaide_instalador
    haroopad_install
    gitkraken_instalador
}
