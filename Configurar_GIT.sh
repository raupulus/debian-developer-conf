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

nombre_git=""
usuario_git=""
correo_git=""

function datos_input() {
    read -p "$verde Introduce el usuario de GITHUB →$rojo " usuario_git
    read -p "$verde Introduce el correo electronico →$rojo  " correo_git
}

#Configurar el usuario GIT local
function configurar_git() {
    git config --global user.name $nombre_git
    git config --global user.email $usuario_git
}

#Configura el usuario en GITHUB
function configurar_github() {
    git config --global github.name $usuario_git
    composer config -g github-oauth.github.com
}

#Crear TOKEN
function crear_token() {
	read -p "$verde Introduce el TOKEN generado, pulsa INTRO si no deseas usar ninguno" TOKEN
	if [ -z $TOKEN ]
	then
		echo -e "$verde No se usará TOKEN$gris"
	else
		echo -e "$verde Generando token con $TOKEN"
	fi
}

#Crear Alias dentro de GIT
function crear_git_alias() {
	echo -e "$verde Alias para el comando$rojo git lg$gris"
	git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

	git config --global push.default simple
}

function configuracion_git() {
    echo -e "$verde Configurando GIT$gris"
    read -p "$verde Introduce el nombre completo del programador →$rojo " nombre_git

    datos_input

    while :
    do
        if [ -z usuario_git ] || [ -z correo_git ]
        then
            echo -e "$verde No puede estar vacio el usuario y el correo$gris"
            datos_input
        else
            break
        fi
    done

    echo -e "$verde Configurando GIT local$gris"
    configurar_git

    echo -e "$verde Configurar conexion con GITHUB"
    configurar_github

	crear_token

	crear_git_alias
}
