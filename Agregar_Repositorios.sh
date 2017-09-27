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
	echo "Instalando llaves de repositorios"
	sudo apt-get install debian-keyring
	sudo apt-get install pkg-mozilla-archive-keyring
	sudo apt-get install deb-multimedia-keyring

	#Multisystem
	sudo wget -q -O - http://liveusb.info/multisystem/depot/multisystem.asc | sudo apt-key add -

	#Webmin
	wget http://www.webmin.com/jcameron-key.asc && apt-key add jcameron-key.asc

	#Virtualbox Oficial
	curl -O https://www.virtualbox.org/download/oracle_vbox_2016.asc
	sudo apt-key add oracle_vbox_2016.asc

	#Docker
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys F76221572C52609D

	#Mi propio repositorio en launchpad
	gpg --keyserver keyserver.ubuntu.com --recv-key B5C6D9592512B8CD && gpg -a --export $PUBKRY | sudo apt-key add -
}

#Añade Repositorios extras a Debian
function agregar_repositorios() {
	echo "Agregando Repositorios"
	sudo cp ./sources.list/sources.list.d/* /etc/apt/sources.list.d/
	sudo mv /etc/apt/sources.list /etc/apt/sources.list.BACKUP
	sudo cp ./sources.list/sources.list /etc/apt/sources.list
	echo "Repositorios Agregados"
	sleep 1

	agregar_llaves
}
