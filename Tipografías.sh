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


function agregar_fuentes() {
    echo "Añadiendo fuentes Tipográficas al sistema"

    fuentes_repositorios="fonts-powerline fonts-freefont-ttf fonts-hack-ttf fonts-lmodern"

    for f in $fuentes_repositorios
    do
        echo -e "$verde Instalando fuente$magenta →$rojo $f $gris"
        sudo apt install -y $f
    done

    fuentes=$(ls ./fonts)
    for f in $fuentes
    do
        if [ -d ./fonts/$f ]
        then
            echo -e "$verde Instalando fuente$magenta →$rojo $f $gris"
            sudo cp -r ./fonts/$f/ /usr/local/share/fonts/
        fi
    done
}
