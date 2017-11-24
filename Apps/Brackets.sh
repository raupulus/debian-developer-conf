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

function brackets_descargar() {
    echo -e "$verde Descargando$rojo Brackets$gris"
}

function brackets_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones de$rojo Brackets$gris"
}

function brackets_instalar() {
    echo -e "$verde Instalando$rojo Brackets$gris"
}

function brackets_postconfiguracion() {
    echo -e "$verde Generando Post-Configuraciones$rojo Brackets$gris"
}

function brackets_instalador() {
    echo -e "$verde Comenzando instalación de$rojo Brackets$gris"
}
