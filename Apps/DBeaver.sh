#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

#Instala el editor de Base de Datos Dbeaver

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

function dbeaver_descargar() {
    echo -e "$verde Descargando$rojo DBeaver$gris"

    REINTENTOS=3
    echo -e "$verde Descargando$rojo Dbeaver$gris"
    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm $DIR_SCRIPT/TMP/dbeaver-ce_latest_amd64.deb 2>> /dev/null
        wget https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb -O $DIR_SCRIPT/TMP/dbeaver-ce_latest_amd64.deb && break
    done
}

function dbeaver_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones de$rojo DBeaver$gris"
}

function dbeaver_instalar() {
    echo -e "$verde Instalando$rojo DBeaver$gris"
    sudo dpkg -i $DIR_SCRIPT/TMP/dbeaver-ce_latest_amd64.deb && sudo apt install -f -y
}

function dbeaver_postconfiguracion() {
    echo -e "$verde Generando Post-Configuraciones$rojo DBeaver$gris"
}

function dbeaver_instalador() {
    echo -e "$verde Comenzando instalación de$rojo DBeaver$gris"

    dbeaver_preconfiguracion

    if [ -f /usr/bin/dbeaver ]
    then
        echo -e "$verde Ya esta$rojo Dbeaver$verde instalado en el equipo, omitiendo paso$gris"
    else
        if [ -f $DIR_SCRIPT/TMP/dbeaver-ce_latest_amd64.deb ]
        then
            dbeaver_instalar
        else
            dbeaver_descargar
            dbeaver_instalar
        fi

        # Si falla la instalación se rellama la función tras limpiar
        if [ ! -f /usr/bin/dbeaver ]
        then
            rm -f $DIR_SCRIPT/TMP/dbeaver-ce_latest_amd64.deb
            dbeaver_descargar
            dbeaver_instalar
        fi
    fi

    dbeaver_postconfiguracion
}
