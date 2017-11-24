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

function haroopad_descargar() {
    echo -e "$verde Descargando$rojo Haroopad$gris"
    REINTENTOS=10
    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm $DIR_SCRIPT/TMP/haroopad-v0.13.1-x64.deb 2>> /dev/null
        wget --show-progress https://bitbucket.org/rhiokim/haroopad-download/downloads/haroopad-v0.13.1-x64.deb -O $DIR_SCRIPT/TMP/haroopad-v0.13.1-x64.deb&& break
    done
}

function haroopad_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones de$rojo Haroopad$gris"
}

function haroopad_instalar() {
    echo -e "$verde Instalando$rojo Haroopad$gris"
    sudo dpkg -i $DIR_SCRIPT/TMP/haroopad-v0.13.1-x64.deb && sudo apt install -f -y
}

function haroopad_postconfiguracion() {
    echo -e "$verde Generando Post-Configuraciones$rojo Haroopad$gris"
}

function haroopad_instalador() {
    echo -e "$verde Comenzando instalación de$rojo Haroopad$gris"

    haroopad_preconfiguracion

    if [ -f /usr/bin/haroopad ]
    then
        echo -e "$verde Ya esta$rojo Haroopad$verde instalado en el equipo, omitiendo paso$gris"
    else
        if [ -f $DIR_SCRIPT/TMP/haroopad-v0.13.1-x64.deb ]
        then
            haroopad_instalar
        else
            haroopad_descargar
            haroopad_instalar
        fi

        # Si falla la instalación se rellama la función tras limpiar
        if [ ! -f /usr/bin/haroopad ]
        then
            rm -f $DIR_SCRIPT/TMP/haroopad-v0.13.1-x64.deb
            haroopad_descargar
            haroopad_instalar
        fi
    fi

    haroopad_postconfiguracion
}
