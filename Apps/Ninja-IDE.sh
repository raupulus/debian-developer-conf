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

function ninjaide_descargar() {
    echo -e "$verde Descargando"
}

function ninjaide_preconfiguracion() {
    echo -e "$verde Generando Pre-Configuraciones"
}

function ninjaide_instalacion() {
    echo -e "$verde Instalando"
}

function ninjaide_postconfiguracion() {
    echo -e "$verde Generando Post-Configuraciones"
}

#Instala el editor de python Ninja IDE
function ninjaide_instalador() {
    ninjaide_descargar
    ninjaide_preconfiguracion
    ninjaide_instalacion
    ninjaide_postconfiguracion

    if [ -f /usr/bin/ninja-ide ]
    then
        echo -e "$verde Ya esta$rojo Ninja IDE$verde instalado en el equipo, omitiendo paso$gris"
    else
        REINTENTOS=3
        echo -e "$verde Descargando$rojo Ninja IDE$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm ninja-ide_2.3-2_all.deb 2>> /dev/null
            wget http://ftp.es.debian.org/debian/pool/main/n/ninja-ide/ninja-ide_2.3-2_all.deb && break
        done
        echo -e "$verde Preparando para instalar$rojo Ninja IDE$gris"
        sudo apt install -y python-qt4 >> /dev/null 2>> /dev/null && echo -e "$verde Se ha instalado$rojo python-qt4$gris" || echo -e "$verde No se ha instalado$rojo python-qt4$gris"
        sudo dpkg -i ninja-ide_2.3-2_all.deb && sudo apt install -f -y
    fi

    #Resolviendo dependencia de libreria QtWebKit.so si no existe
    sudo apt install libqtwebkit4 2>> /dev/null
    if [ ! -f /usr/lib/python2.7/dist-packages/PyQt4/QtWebKit.so ]
    then
        echo -e "$verde Añadiendo libreria$rojo QtWebKit$gris"
        sudo mkdir -p /usr/lib/python2.7/dist-packages/PyQt4/ 2>> /dev/null
        sudo cp ./LIB/usr/lib/python2.7/dist-packages/PyQt4/QtWebKit.so /usr/lib/python2.7/dist-packages/PyQt4/
    fi

    #Resolviendo otras dependencia de plugins para Ninja IDE
    echo -e "Resolviendo otras dependencias para plugins de Ninja IDE"
    sudo apt install -y python-git python3-git 2>> /dev/null
}
