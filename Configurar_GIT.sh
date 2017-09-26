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
    read -p "Introduce el usuario de GITHUB → " usuario_git
    read -p "Introduce el correo electronico → " correo_git
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

function configuracion_git() {
    echo -e "$verde Configurando GIT$gris"
    read -p "Introduce el nombre completo del programador → " nombre_git

    datos_input

    while :
    do
        if [ -z usuario_git ] || [ -z correo_git ]
        then
            echo -e "$verde No puede estar vacio el usuario y el correo"
            datos_input
        else
            break
        fi
    done

    echo -e "$verde Configurando GIT local$gris"
    configurar_git

    echo -e "$verde Configurar conexion con GITHUB"
    configurar_github
}
