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
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

############################
##       CONSTANTES       ##
############################
AM="\033[1;33m"  ## Color Amarillo
AZ="\033[1;34m"  ## Color Azul
BL="\033[1;37m"  ## Color Blanco
CY="\033[1;36m"  ## Color Cyan
GR="\033[0;37m"  ## Color Gris
MA="\033[1;35m"  ## Color Magenta
RO="\033[1;31m"  ## Color Rojo
VE="\033[1;32m"  ## Color Verde
CL="\e[0m"       ## Limpiar colores

#############################
##   Variables Generales   ##
#############################

############################
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################

function configurar_iconos(){
    echo -e "$VE Configurando pack de iconos$CL"
    if [ -f "./Paper_Icon.deb" ]
    then
        echo -e "$VE Ya esta$RO Paper_Icon.deb$VE descargado, omitiendo paso$CL"
    else
        REINTENTOS=5
        echo -e "$VE Descargando$RO Paper_Icon.deb$CL"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm ./Paper_Icon.deb 2>> /dev/null
            wget "https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-icon-theme,16.04" -O Paper_Icon.deb && break
        done
        echo -e "$VE Preparando para instalar$RO Iconos Paper_Icon$CL"
        sudo dpkg -i Paper_Icon.deb && sudo apt install -f -y
    fi

    #TODO → Establecer "Paper_Icon" como iconos activos
}

function configurar_cursores(){
    echo -e "$VE Configurando pack de cursores$CL"
    sudo apt install -y crystalcursors
    sudo update-alternatives --set x-cursor-theme /etc/X11/cursors/crystalblue.theme 2>> /dev/null
}

function configurar_temas(){
    echo -e "$VE Configurando temas GTK$CL"

    if [ -f "./Paper_Theme.deb" ]
    then
        echo -e "$VE Ya esta$RO Paper_Theme.deb$VE descargado, omitiendo paso$CL"
    else
        REINTENTOS=5
        echo -e "$VE Descargando$RO Paper_Theme.deb$CL"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm ./Paper_Theme.deb 2>> /dev/null
            wget "https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-gtk-theme,16.04" -O Paper_Theme.deb && break
        done
        echo -e "$VE Preparando para instalar$RO Iconos Paper_Theme$CL"
        sudo dpkg -i Paper_Theme.deb && sudo apt install -f -y
    fi

    # Instalar Flat-Plat
    if [ -f "./materia-theme-20170605/install.sh" ]
    then
        echo -e "$VE Ya esta$RO Flat-Plat$VE descargado, omitiendo paso$CL"
    else
        REINTENTOS=5
        echo -e "$VE Descargando$RO Flat-Plat$CL"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm -r ./materia-theme-20170605 2>> /dev/null
            curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170605.tar.gz | tar xz && break
        done
        echo -e "$VE Preparando para instalar$RO Tema Flat-Plat$CL"
        sudo ./materia-theme-20170605/install.sh #2>> /dev/null
    fi

    #TODO → Establecer Flat-Plat como tema activos

    #echo -e "$VE Configurando temas QT$CL"
}

function configurar_grub() {
    echo -e "$VE Configurando fondo del grub$CL"
    #Realmente se hace al copiar fondos en la función "configurar_fondos"
}

function configurar_fondos {
    echo -e "$VE Configurando fondo de pantalla$CL"
    sudo cp -r ./usr/share/desktop-base/softwaves-themes/* /usr/share/desktop-base/softwaves-theme/
    echo -e "$VE Configurando plymouth$CL"
    sudo cp -r ./usr/share/plymouth/themes/softwaves/* /usr/share/plymouth/themes/softwaves/
}

function personalizar() {
    echo -e "$VE Iniciando configuracion de estética general y GTK$CL"
    configurar_iconos
    configurar_cursores
    configurar_temas
    configurar_grub
    configurar_fondos
}
