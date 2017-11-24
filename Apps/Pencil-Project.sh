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

function pencilProject_descargar() {
    echo -e "$verde Descargando$rojo Pencil Project$gris"
    REINTENTOS=10
    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm $DIR_SCRIPT/TMP/Pencil_Project.deb 2>> /dev/null
        wget --show-progress http://pencil.evolus.vn/dl/V3.0.4/Pencil_3.0.4_amd64.deb -O $DIR_SCRIPT/TMP/Pencil_Project.deb && break
    done
}

function pencilProject_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones de$rojo Pencil Project$gris"
}

function pencilProject_instalar() {
    echo -e "$verde Instalando$rojo Pencil Project$gris"
    sudo dpkg -i $DIR_SCRIPT/TMP/Pencil_Project.deb && sudo apt install -f -y
}

function pencilProject_postconfiguracion() {
    echo -e "$verde Generando Post-Configuraciones$rojo Pencil Project$gris"
}

function pencilProject_instalador() {
    echo -e "$verde Comenzando instalación de$rojo Pencil Project$gris"

    pencilProject_preconfiguracion

    if [ -f /usr/bin/pencil ]
    then
        echo -e "$verde Ya esta$rojo Pencil Project$verde instalado en el equipo, omitiendo paso$gris"
    else
        if [ -f $DIR_SCRIPT/TMP/Pencil_Project.deb ]
        then
            pencilProject_instalar
        else
            pencilProject_descargar
            pencilProject_instalar
        fi

        # Si falla la instalación se rellama la función tras limpiar
        if [ ! -f /usr/bin/pencil ]
        then
            rm -f $DIR_SCRIPT/TMP/Pencil_Project.deb
            pencilProject_descargar
            pencilProject_instalar
        fi
    fi

    pencilProject_postconfiguracion
}
