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

function configurar_iconos(){
    echo -e "$verde Configurando pack de iconos$gris"
}

function configurar_cursores(){
    echo -e "$verde Configurando pack de cursores$gris"
}

function configurar_grub() {
    echo -e "$verde Configurando fondo del grub$gris"
}

function configurar_fondos {
    echo -e "$verde Configurando fondo de pantalla$gris"
}

function personalizar() {
    echo -e "$verde Iniciando configuracion de estetica general y GTK$gris"
    configurar_iconos
    configurar_cursores
    configurar_grub
    configurar_fondos
}
