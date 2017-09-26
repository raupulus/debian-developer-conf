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
	echo -e "$verde Comprobando descargas incompletas$gris"
	#FIXME --> Puede no ser lo más eficiente, comprobar si es idéntico al original antes de borrar
	if [ -d ./fonts/powerline ] #Borrar el directorio si ya existe
	then
		rm -r ./fonts/powerline
	fi

	echo -e "$verde Clonando Repositorio$rojo PowerLine$amarillo"
	git clone https://github.com/powerline/fonts.git ./fonts/powerline
	echo -e "$verde Se ha completado la descarga$gris"

	echo -e "$verde Preparando fuentes para añadir$gris"
	fuentes=$(ls ./fonts/powerline/)
	for f in $fuentes
	do
		if [ -d ./fonts/powerline/$f ] #Si es un directorio añade las fuentes contenidas
		then
			echo -e "$verde Instalando fuente$magenta →$rojo $f $gris"
			sleep 1
			#sudo cp -r ./fonts/powerline/$f/ /usr/local/share/fonts/
			sleep 1
		fi
	done
}

function agregar_fuentes() {
	#powerline

	echo "Añadiendo fuentes Tipográficas al sistema"
	fuentes=$(ls ./fonts)
	for f in $fuentes
	do
		if [ -d ./fonts/$f ] #Si es un directorio añade las fuentes contenidas
		then
			echo -e "$verde Instalando fuente$magenta →$rojo $f $gris"
			sleep 1
			#sudo cp -r ./fonts/$f/ /usr/local/share/fonts/
			sleep 1
		fi
	done

	powerline #Llama a la función powerline()
}

agregar_fuentes
