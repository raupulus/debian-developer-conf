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

#Instala el script de OhMyZSH
function ohMyZSH() {
	echo -e "$verde Descargando OhMyZSH$gris"
	curl -L http://install.ohmyz.sh | sh
}

#Agregar Archivos de configuración al home
function agregar_conf_home() {
  	conf=$(ls -A ./home/)
	echo -e "$verde Preparando para añadir archivos de configuración en el home de usuario$gris"
	for c in $conf
	do
		if [ -f ~/$c ] || [ -d ~/$c ] #Si existe hago backup
		then
			echo -e "$verde Creando backup de ~/home/$(whoami)/$c $gris"
			mv ~/$c ~/$c.BACKUP
		fi
		echo -e "$verde Generando configuración$gris"
		mv ./home/$c ~/$c
	done
}

#Permisos
function permisos() {
    #TODO --> Quitar permios para atom como superusuario
	echo -e "$verde Estableciendo permisos en el sistema$gris"
}

#Establecer programas por defecto
function programas_default() {
	echo -e "$verde Estableciendo programas por defecto$gris"
	#sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix
}

#Elegir intérprete de comandos
function terminal() {
  while true
  do
  	read -p "$verde Introduce el terminal →$rojo bash/zsh $azul" term
  	case $term in
		bash)#Establecer bash como terminal
			chsh -s /bin/bash
			break;;
		zsh)#Establecer zsh como terminal
			chsh -s /bin/zsh
			break;;
		*)#Opción errónea
			echo -e "$rojo Opción no válida"
			break;;
	esac
  done
}

#Instalar Todas las configuraciones
function instalar_configuraciones() {
  	agregar_conf_home
	ohMyZSH
	permisos
	programas_default
	terminal #Pregunta el terminal a usar
}
