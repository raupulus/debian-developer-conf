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
