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

function brackets_descargar() {
    echo -e "$verde Descargando$rojo Brackets$gris"

    REINTENTOS=10
    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm Brackets.Release.1.10.64-bit.deb 2>> /dev/null
        wget https://github.com/adobe/brackets/releases/download/release-1.10/Brackets.Release.1.10.64-bit.deb && break
    done

    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm libgcrypt11_1.5.0-5+deb7u6_amd64.deb 2>> /dev/null
        wget http://security.debian.org/debian-security/pool/updates/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u6_amd64.deb && break
    done
}

function brackets_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones de$rojo Brackets$gris"
}

function brackets_instalar() {
    echo -e "$verde Preparando para instalar$rojo Brackets$gris"
    sudo dpkg -i libgcrypt11_1.5.0-5+deb7u6_amd64.deb

    echo -e "$verde Instalando$rojo Brackets$gris"
    sudo dpkg -i Brackets.Release.1.10.64-bit.deb && sudo apt install -f -y
}

function brackets_postconfiguracion() {
    echo -e "$verde Generando Post-Configuraciones$rojo Brackets$gris"
}

function brackets_instalador() {
    echo -e "$verde Comenzando instalación de$rojo Brackets$gris"

    brackets_preconfiguracion

    if [ -f /usr/bin/brackets ]
    then
        echo -e "$verde Ya esta$rojo Brackets$verde instalado en el equipo, omitiendo paso$gris"
    else
        if [ -f $DIR_SCRIPT/TMP/Brackets.Release.1.10.64-bit.deb ]
        then
            brackets_instalar
        else
            brackets_descargar
            brackets_instalar
        fi

        # Si falla la instalación se rellama la función tras limpiar
        if [ ! -f /usr/bin/brackets ]
        then
            rm -f $DIR_SCRIPT/TMP/Brackets.Release.1.10.64-bit.deb
            brackets_descargar
            brackets_instalar
        fi
    fi

    brackets_postconfiguracion
}
