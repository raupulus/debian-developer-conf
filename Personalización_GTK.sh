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
    if [ -f "./Paper_Icon.deb" ]
	then
		echo -e "$verde Ya esta$rojo Paper_Icon.deb$verde descargado, omitiendo paso$gris"
	else
		REINTENTOS=5
		echo -e "$verde Descargando$rojo Paper_Icon.deb$gris"
		for (( i=1; i<=$REINTENTOS; i++ ))
		do
			rm ./Paper_Icon.deb 2>> /dev/null
			wget "https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-icon-theme,16.04" -O Paper_Icon.deb && break
		done
		echo -e "$verde Preparando para instalar$rojo Iconos Paper_Icon$gris"
		sudo dpkg -i Paper_Icon.deb && sudo apt install -f -y
    fi
}

function configurar_cursores(){
    echo -e "$verde Configurando pack de cursores$gris"
    sudo apt install crystalcursors
    #TODO → establecer cursor en la configuración
}

function configurar_temas(){
    echo -e "$verde Configurando temas GTK$gris"

    if [ -f "./Paper_Theme.deb" ]
	then
		echo -e "$verde Ya esta$rojo Paper_Theme.deb$verde descargado, omitiendo paso$gris"
	else
		REINTENTOS=5
		echo -e "$verde Descargando$rojo Paper_Theme.deb$gris"
		for (( i=1; i<=$REINTENTOS; i++ ))
		do
			rm ./Paper_Theme.deb 2>> /dev/null
			wget "https://snwh.org/paper/download.php?owner=snwh&ppa=pulp&pkg=paper-gtk-theme,16.04" -O Paper_Theme.deb && break
		done
		echo -e "$verde Preparando para instalar$rojo Iconos Paper_Theme$gris"
		sudo dpkg -i Paper_Theme.deb && sudo apt install -f -y
    fi

    if [ -f "./Flat-Plat-20170605/install.sh" ]
	then
		echo -e "$verde Ya esta$rojo Flat-Plat$verde descargado, omitiendo paso$gris"
	else
		REINTENTOS=5
		echo -e "$verde Descargando$rojo Flat-Plat$gris"
		for (( i=1; i<=$REINTENTOS; i++ ))
		do
			rm -r ./Flat-Plat-20170605 2>> /dev/null
			curl -sL https://github.com/nana-4/Flat-Plat/archive/v20170605.tar.gz | tar xz && break
		done
		echo -e "$verde Preparando para instalar$rojo Tema Flat-Plat$gris"
		sudo ./Flat-Plat-20170605/install.sh
    fi

    #echo -e "$verde Configurando temas QT$gris"
}

function configurar_grub() {
    echo -e "$verde Configurando fondo del grub$gris"
}

function configurar_fondos {
    echo -e "$verde Configurando fondo de pantalla$gris"
    sudo cp -r ./usr/share/desktop-base/softwaves-themes/* /usr/share/desktop-base/softwaves-theme/
    echo -e "$verde Configurando plymouth$gris"
    sudo cp -r ./usr/share/plymouth/themes/softwaves/* /usr/share/plymouth/themes/softwaves/
}

function personalizar() {
    echo -e "$verde Iniciando configuracion de estetica general y GTK$gris"
    configurar_iconos
    configurar_cursores
    configurar_temas
    configurar_grub
    configurar_fondos
}
