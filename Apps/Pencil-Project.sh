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
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################


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
