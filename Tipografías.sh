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

#Agregar fuentes desde repositorio PowerLine
function powerline() {
	echo -e "$verde Clonando Repositorio$rojo PowerLine$amarillo"
	git clone https://github.com/powerline/fonts.git ./fonts/
	echo -e "$verde Se ha completado la descarga$gris"
}

function agregar_fuentes() {
	powerline

	echo "Añadiendo fuentes Tipográficas al sistema"
	fuentes=$(ls fonts)
	for f in $fuentes
	do
		echo -e "$verde Instalando fuente$magenta →$rojo $f $gris"
		sleep 1
		sudo cp ./fonts/$f /usr/local/share/fonts/
		sleep 1
	done
}
