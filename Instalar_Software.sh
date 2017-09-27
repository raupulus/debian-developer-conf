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
    echo -e "$verde Instalando Atom $gris"
	#Temporalmente se aplica descarga directa
	wget https://atom.io/download/deb
	mv deb atom.deb
	sudo dpkg -i atom.deb
	sudo apt install -f -y

    echo -e "$verde Preparando instalación complementos Atom$gris"
    for p in $atom
    do
        echo -e "$verde Instalando $p $yellow"
        apm install $p
    done
}

#Instala complementos para Brackets IDE
function brackets_install () {
  	echo -e "$verde Preparando para instalar brackets$gris"
	#Temporalmente se aplica descarga directa
	wget https://github.com/adobe/brackets/releases/download/release-1.11/Brackets.Release.1.11.64-bit.deb
	sudo dpkg -i Brackets.Release.1.11.64-bit.deb
	sudo apt install -f
}

function dbeaver_install() {
	echo -e "$verde Preparando instalacion para DBeaver"
	#Temporalmente se aplica descarga directa
	wget https://dbeaver.jkiss.org/files/dbeaver-ce_latest_amd64.deb
	sudo dpkg -i dbeaver-ce_latest_amd64.deb
	sudo apt install -f
}

function ninjaide_install() {
	echo -e "$verde Preparando instalacion para Ninja IDE"
	wget http://ftp.es.debian.org/debian/pool/main/n/ninja-ide/ninja-ide_2.3-2_all.deb
	sudo dpkg -i ninja-ide_2.3-2_all.deb
	sudo apt install -f

	#Resolviendo libreria QtWebKit.so
	mkdir -p /usr/lib/python2.7/dist-packages/PyQt4/ 2>> /dev/null
	cp ./LIB/usr/lib/python2.7/dist-packages/PyQt4/QtWebKit.so /usr/lib/python2.7/dist-packages/PyQt4/
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

	#Instalaciones de software independiente
	atom_install
    brackets_install
	dbeaver_install
	ninjaide_install
}
