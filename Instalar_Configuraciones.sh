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
}

#Agregar Archivos de configuración al home
function agregar_conf_home() {
	echo -e "$verde Preparando para añadir archivos de configuración en el home de usuario$gris"
}

#Permisos
function permisos() {
    #TODO --> Quitar permios para atom como superusuario
}

#Instalar Todas las configuraciones
function instalar_configuraciones() {
    agregar_conf_home
	ohMyZSH
	permisos
}
