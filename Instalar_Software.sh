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
software=$(cat Software.lst) #Instala software del S.O.
atom=$(cat Atom_Paquetes.lst) #Instala Paquetes de Atom

#Instala complementos para Atom IDE
function atom_install() {
    echo -e "$verde Preparando instalación complementos Atom"
    for p in $atom
    do
        echo -e "$verde Instalando $p"
        apm install $p
    done
}

#Instala complementos para Brackets IDE
function brackets_install () {

}

#Recorrer "Software.lst" Instalando paquetes ahí descritos
function instalar_Software() {
	echo "Actualizando listas de Repositorios"
	sudo apt update
	echo "Instalando Software adicional"
	for s in $software
	do
		echo -e "$verde Preparando para instalar $rojo$s$gris"
		sleep 1
		sudo apt install -y $s
	done

    echo -e "Instalando Atom"
    atom_install

    echo -e "Instalando Brackets"
    brackets_install
}
