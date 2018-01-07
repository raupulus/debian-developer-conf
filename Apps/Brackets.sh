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

function brackets_descargar() {
    echo -e "$VE Descargando$RO Brackets$CL"
    descargar 'Brackets.deb' "https://github.com/adobe/brackets/releases/download/release-1.10/Brackets.Release.1.10.64-bit.deb"

    for (( i=1; i<=$REINTENTOS; i++ ))
    do
        rm $WORKSCRIPT/TMP/libgcrypt11_1.5.0-5+deb7u6_amd64.deb 2>> /dev/null
        wget http://security.debian.org/debian-security/pool/updates/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u6_amd64.deb -O $WORKSCRIPT/TMP/libgcrypt11_1.5.0-5+deb7u6_amd64.deb && break
    done
}

function brackets_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Brackets$CL"
}

function brackets_instalar() {
    echo -e "$VE Preparando para instalar$RO Brackets$CL"
    sudo dpkg -i $WORKSCRIPT/TMP/libgcrypt11_1.5.0-5+deb7u6_amd64.deb

    echo -e "$VE Instalando$RO Brackets$CL"
    sudo dpkg -i $WORKSCRIPT/TMP/Brackets.Release.1.10.64-bit.deb && sudo apt install -f -y
}

function brackets_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Brackets$CL"
}

function brackets_instalador() {
    echo -e "$VE Comenzando instalación de$RO Brackets$CL"

    brackets_preconfiguracion

    if [ -f /usr/bin/brackets ]
    then
        echo -e "$VE Ya esta$RO Brackets$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [ -f $WORKSCRIPT/TMP/Brackets.Release.1.10.64-bit.deb ]
        then
            brackets_instalar
        else
            brackets_descargar
            brackets_instalar
        fi

        # Si falla la instalación se rellama la función tras limpiar
        if [ ! -f /usr/bin/brackets ]
        then
            rm -f $WORKSCRIPT/TMP/Brackets.Release.1.10.64-bit.deb
            brackets_descargar
            brackets_instalar
        fi
    fi

    brackets_postconfiguracion
}
