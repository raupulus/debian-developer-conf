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
	git clone
}

#Agregar Archivos de configuración al home
function agregar_conf_home() {
  	conf=$(ls -lA ./home/)
	echo -e "$verde Preparando para añadir archivos de configuración en el home de usuario$gris"
	for c in $conf
	do
		if [ -f ~/home/$c ] || [ -d ~/home/$c ] #Si existe hago backup
		then
			echo -e "$verde Creando backup de ~/home/$c $gris"
			mv "~/home/$c" "~/home/$c.BACKUP"
		fi
		echo -e "$verde Generando configuración$gris"
		mv "./home/$c" "~/home/$c"
	done
}

#Permisos
function permisos() {
    #TODO --> Quitar permios para atom como superusuario
}

#Establecer programas por defecto
function programas_default() {
  	#sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix
}

#Instalar Todas las configuraciones
function instalar_configuraciones() {
  	agregar_conf_home
	ohMyZSH
	permisos
	programas_default
}
