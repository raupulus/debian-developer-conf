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

function brackets_descargar() {
    echo -e "$verde Descargando$rojo Brackets$gris"

    REINTENTOS=10
    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm $DIR_SCRIPT/TMP/Brackets.Release.1.10.64-bit.deb 2>> /dev/null
        wget https://github.com/adobe/brackets/releases/download/release-1.10/Brackets.Release.1.10.64-bit.deb -O $DIR_SCRIPT/TMP/Brackets.Release.1.10.64-bit.deb && break
    done

    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm $DIR_SCRIPT/TMP/libgcrypt11_1.5.0-5+deb7u6_amd64.deb 2>> /dev/null
        wget http://security.debian.org/debian-security/pool/updates/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u6_amd64.deb -O $DIR_SCRIPT/TMP/libgcrypt11_1.5.0-5+deb7u6_amd64.deb && break
    done
}

function brackets_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones de$rojo Brackets$gris"
}

function brackets_instalar() {
    echo -e "$verde Preparando para instalar$rojo Brackets$gris"
    sudo dpkg -i $DIR_SCRIPT/TMP/libgcrypt11_1.5.0-5+deb7u6_amd64.deb

    echo -e "$verde Instalando$rojo Brackets$gris"
    sudo dpkg -i $DIR_SCRIPT/TMP/Brackets.Release.1.10.64-bit.deb && sudo apt install -f -y
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
