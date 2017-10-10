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
    # TODO → Controlar errores en la descarga o borrar y volver a descargar
    #wget "https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-icon-theme,16.04" -O Paper_Icon.deb
    # TODO → Instalar software si se ha descargado correctamente
    # sudo dpkg -i Paper_Icon.deb
    # sudo apt install -f
}

function configurar_cursores(){
    echo -e "$verde Configurando pack de cursores$gris"
    sudo apt install crystalcursors
    #TODO → establecer cursor en la configuración
}

function configurar_temas(){
    echo -e "$verde Configurando temas GTK$gris"
    # TODO → Controlar errores en la descarga o borrar y volver a descargar
    #wget "https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-gtk-theme,16.04" -O Paper_Theme.deb
    # TODO → Instalar software si se ha descargado correctamente
    # sudo dpkg -i Paper_Theme.deb
    # sudo apt install -f

    #Instalar tema Flat-Plat
    #curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170605.tar.gz | tar xz
    #cd Flat-Plat-20170605 && sudo ./install.sh

    echo -e "$verde Configurando temas QT$gris"
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
    configurar_temas
    configurar_grub
    configurar_fondos
}
