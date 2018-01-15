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
##       CONSTANTES       ##
############################
AM="\033[1;33m"  ## Color Amarillo
AZ="\033[1;34m"  ## Color Azul
BL="\033[1;37m"  ## Color Blanco
CY="\033[1;36m"  ## Color Cyan
GR="\033[0;37m"  ## Color CL
MA="\033[1;35m"  ## Color Magenta
RO="\033[1;31m"  ## Color RO
VE="\033[1;32m"  ## Color VE
CL="\e[0m"       ## Limpiar colores

#############################
##   Variables Generales   ##
#############################

############################
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################

function agregar_llaves() {
    echo -e "$Ve Instalando llaves de repositorios$CL"

    sudo apt install -y debian-keyring 2>> /dev/null
    sudo apt install -y pkg-mozilla-archive-keyring 2>> /dev/null
    sudo apt install -y deb-multimedia-keyring 2>> /dev/null

    # Multisystem
    echo -e "$Ve Agregando clave para$RO Multisystem$CL"
    sudo wget -q -O - http://liveusb.info/multisystem/depot/multisystem.asc | sudo apt-key add -

    # Webmin
    echo -e "$Ve Agregando clave para$RO Webmin$CL"
    wget http://www.webmin.com/jcameron-key.asc && sudo apt-key add jcameron-key.asc
    sudo rm jcameron-key.asc

    # Virtualbox Oficial
    echo -e "$Ve Agregando clave para$RO Virtualbox$CL"
    wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
    sudo apt-key add oracle_vbox_2016.asc
    sudo rm oracle_vbox_2016.asc

    # Docker
    echo -e "$Ve Agregando clave para$RO Docker$CL"
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys F76221572C52609D

    ## Heroku
    echo -e "$Ve Agregando clave para$RO Heroku$CL"
    curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -

    # Mi propio repositorio en launchpad
    echo -e "$Ve Agregando clave para$RO Fryntiz Repositorio$CL"
    gpg --keyserver keyserver.ubuntu.com --recv-key B5C6D9592512B8CD && gpg -a --export $PUBKRY | sudo apt-key add -

    # Repositorio de PostgreSQL
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
}

#Añade Repositorios extras a Debian
function agregar_repositorios() {
    echo -e "$Ve Actualizando repositorios por primera vez$CL"
    sudo apt update >> /dev/null 2>> /dev/null
    sudo apt install -y apt-transport-https >> /dev/null && echo -e "$Ve Instalado el paquete$RO apt-transport-https$CL" || echo -e "$Ve Error al instalar$RO apt-transport-https$CL"
    sudo apt install -y dirmngr >> /dev/null && echo -e "$Ve Instalado el paquete$RO dirmngr$CL" || echo -e "$Ve Error al instalar$RO dirmngr$CL"
    echo -e "$Ve Agregando Repositorios$CL"
    sudo cp ./sources.list/sources.list.d/* /etc/apt/sources.list.d/ 2>> /dev/null
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.BACKUP 2>> /dev/null
    sudo cp ./sources.list/sources.list /etc/apt/sources.list 2>> /dev/null
    echo -e "$Ve Repositorios Agregados$CL"
    sleep 3

    echo -e "$Ve Actualizando listas de repositorios por segunda vez$CL"
    sudo apt update >> /dev/null 2>> /dev/null
    agregar_llaves
    echo -e "$Ve Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    sudo apt update
}
