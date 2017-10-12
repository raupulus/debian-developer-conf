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

function agregar_llaves() {
    echo -e "$verde Instalando llaves de repositorios$gris"

    sudo apt install -y debian-keyring 2>> /dev/null
    sudo apt install -y pkg-mozilla-archive-keyring 2>> /dev/null
    sudo apt install -y deb-multimedia-keyring 2>> /dev/null

    #Multisystem
    echo -e "$verde Agregando clave para$rojo Multisystem$gris"
    sudo wget -q -O - http://liveusb.info/multisystem/depot/multisystem.asc | sudo apt-key add -

    #Webmin
    echo -e "$verde Agregando clave para$rojo Webmin$gris"
    wget http://www.webmin.com/jcameron-key.asc && sudo apt-key add jcameron-key.asc
    sudo rm jcameron-key.asc

    #Virtualbox Oficial
    echo -e "$verde Agregando clave para$rojo Virtualbox$gris"
    wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
    sudo apt-key add oracle_vbox_2016.asc
    sudo rm oracle_vbox_2016.asc

    #Docker
    echo -e "$verde Agregando clave para$rojo Docker$gris"
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys F76221572C52609D

    #Mi propio repositorio en launchpad
    echo -e "$verde Agregando clave para$rojo Fryntiz Repositorio$gris"
    gpg --keyserver keyserver.ubuntu.com --recv-key B5C6D9592512B8CD && gpg -a --export $PUBKRY | sudo apt-key add -
}

#Añade Repositorios extras a Debian
function agregar_repositorios() {
    echo -e "$verde Actualizando repositorios por primera vez$gris"
    sudo apt update >> /dev/null 2>> /dev/null
    sudo apt install -y apt-transport-https >> /dev/null && echo -e "$verde Instalado el paquete$rojo apt-transport-https$gris" || echo -e "$verde Error al instalar$rojo apt-transport-https$gris"
    sudo apt install -y dirmngr >> /dev/null && echo -e "$verde Instalado el paquete$rojo dirmngr$gris" || echo -e "$verde Error al instalar$rojo dirmngr$gris"
    echo -e "$verde Agregando Repositorios$gris"
    sudo cp ./sources.list/sources.list.d/* /etc/apt/sources.list.d/ 2>> /dev/null
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.BACKUP 2>> /dev/null
    sudo cp ./sources.list/sources.list /etc/apt/sources.list 2>> /dev/null
    echo -e "$verde Repositorios Agregados$gris"
    sleep 3

    echo -e "$verde Actualizando listas de repositorios$gris"
    sudo apt update 2>> /dev/null
    agregar_llaves
    echo -e "$verde Actualizando listas de repositorios$gris"
    sudo apt update
}
