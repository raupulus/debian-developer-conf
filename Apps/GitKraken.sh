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
DIR_SCRIPT=`echo $PWD`

function gitkraken_descargar() {
    echo -e "$verde Descargando$rojo GitKraken$gris"

    REINTENTOS=10
    echo -e "$verde Descargando$rojo Gitkraken$gris"
    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm $DIR_SCRIPT/TMP/gitkraken-amd64.deb 2>> /dev/null
        wget --show-progress https://release.gitkraken.com/linux/gitkraken-amd64.deb -O $DIR_SCRIPT/TMP/gitkraken-amd64.deb && break
    done
}

function gitkraken_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones de$rojo GitKraken$gris"
}

function gitkraken_instalar() {
    echo -e "$verde Instalando$rojo GitKraken$gris"
    sudo dpkg -i $DIR_SCRIPT/TMP/gitkraken-amd64.deb && sudo apt install -f -y
}

function gitkraken_postconfiguracion() {
    echo -e "$verde Generando Post-Configuraciones$rojo GitKraken$gris"
}

function gitkraken_instalador() {
    echo -e "$verde Comenzando instalación de$rojo GitKraken$gris"

    gitkraken_preconfiguracion

    if [ -f /usr/bin/gitkraken ]
    then
        echo -e "$verde Ya esta$rojo Gitkraken$verde instalado en el equipo, omitiendo paso$gris"
    else
        if [ -f $DIR_SCRIPT/TMP/gitkraken-amd64.deb ]
        then
            gitkraken_instalar
        else
            gitkraken_descargar
            gitkraken_instalar
        fi

        # Si falla la instalación se rellama la función tras limpiar
        if [ ! -f /usr/bin/gitkraken ]
        then
            rm -f $DIR_SCRIPT/TMP/gitkraken-amd64.deb
            gitkraken_descargar
            gitkraken_instalar
        fi
    fi

    gitkraken_postconfiguracion
}
