#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

# Este script contiene aplicaciones que son opcionales como editores

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

source Apps/Atom_IDE.sh
source Apps/Ninja-IDE.sh
source Apps/Brackets.sh
source Apps/DBeaver.sh
source Apps/GitKraken.sh
source Apps/Haroopad.sh
source Apps/Pencil-Project.sh

function instalar_Software_Extra() {
    echo -e "$verde Preparando para instalar software Extra$gris"
    atom_instalador
    brackets_instalador
    dbeaver_instalador
    ninjaide_instalador
    haroopad_instalador
    gitkraken_instalador
}
