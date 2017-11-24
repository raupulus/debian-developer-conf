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

# Añadir entrada al menú principal para separar aplicaciones básicas de las
# aplicaciones de las extras como firefox-developer, gitkraken etc etc...

source Apps/Atom_IDE.sh

#Instala complementos para Brackets IDE
function brackets_install() {
    if [ -f /usr/bin/brackets ]
    then
        echo -e "$verde Ya esta$rojo Brackets$verde instalado en el equipo, omitiendo paso$gris"
    else
        REINTENTOS=10
        echo -e "$verde Descargando$rojo Brackets$gris"
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

        echo -e "$verde Preparando para instalar$rojo Brackets$gris"
        sudo dpkg -i libgcrypt11_1.5.0-5+deb7u6_amd64.deb
        sudo dpkg -i Brackets.Release.1.10.64-bit.deb && sudo apt install -f -y
    fi
}

#Instala el editor de Base de Datos Dbeaver
function dbeaver_install() {
    if [ -f /usr/bin/dbeaver ]
    then
        echo -e "$verde Ya esta$rojo Dbeaver$verde instalado en el equipo, omitiendo paso$gris"
    else
        REINTENTOS=3
        echo -e "$verde Descargando$rojo Dbeaver$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm dbeaver-ce_latest_amd64.deb 2>> /dev/null
            wget https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb && break
        done
        echo -e "$verde Preparando para instalar$rojo Dbeaver$gris"
        sudo dpkg -i dbeaver-ce_latest_amd64.deb && sudo apt install -f -y
    fi
}

#Instala el editor de python Ninja IDE
function ninjaide_install() {
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

function haroopad_install() {
    if [ -f /usr/bin/haroopad ]
    then
        echo -e "$verde Ya esta$rojo Haroopad$verde instalado en el equipo, omitiendo paso$gris"
    else
        REINTENTOS=3
        echo -e "$verde Descargando$rojo Haroopad$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm haroopad-v0.13.1-x64.deb 2>> /dev/null
            wget --show-progress https://bitbucket.org/rhiokim/haroopad-download/downloads/haroopad-v0.13.1-x64.deb && break
        done
        echo -e "$verde Preparando para instalar$rojo Haroopad$gris"
        sudo dpkg -i haroopad-v0.13.1-x64.deb && sudo apt install -f -y
    fi
}

function gitkraken_install() {
    if [ -f /usr/bin/gitkraken ]
    then
        echo -e "$verde Ya esta$rojo Gitkraken$verde instalado en el equipo, omitiendo paso$gris"
    else
        REINTENTOS=3
        echo -e "$verde Descargando$rojo Gitkraken$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm gitkraken-amd64.deb 2>> /dev/null
            wget --show-progress https://release.gitkraken.com/linux/gitkraken-amd64.deb && break
        done
        echo -e "$verde Preparando para instalar$rojo Gitkraken$gris"
        sudo dpkg -i gitkraken-amd64.deb && sudo apt install -f -y
    fi
}

function instalar_Software_Extra() {
    echo -e "$verde Preparando para instalar software Extra$gris"
    atom_install
    brackets_install
    dbeaver_install
    ninjaide_install
    haroopad_install
    gitkraken_install
}
