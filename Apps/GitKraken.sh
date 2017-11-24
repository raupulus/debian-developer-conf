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

function gitkraken_descargar() {
    echo -e "$verde Descargando$rojo GitKraken$gris"
}

function gitkraken_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones de$rojo GitKraken$gris"
}

function gitkraken_instalar() {
    echo -e "$verde Instalando$rojo GitKraken$gris"
}

function gitkraken_postconfiguracion() {
    echo -e "$verde Generando Post-Configuraciones$rojo GitKraken$gris"
}

function gitkraken_instalador() {
    echo -e "$verde Comenzando instalación de$rojo GitKraken$gris"
}
