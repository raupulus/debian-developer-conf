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
TOKEN=""

function datos_input() {
    read -p "Introduce el usuario de GITHUB → " usuario_git
    read -p "Introduce el correo electronico → " correo_git
}

#Configurar el usuario GIT local
function configurar_git() {
	DIR_ACTUAL=$(echo $PWD)
	cd #Cambio al directorio home para que no de problemas GIT
    git config --global user.name $nombre_git
    git config --global user.email $correo_git
	git config --global core.editor vim
	git config --global color.ui true

	#Reparar finales de linea que mete la mierda de windows CRLF to LF
	git config --global core.autocrlf input

	cd $DIR_ACTUAL
}

#Configura el usuario en GITHUB
function configurar_github() {
    git config --global github.name $nombre_git
    #TOFIX →   github-oauth.github.com is not defined.
	#composer config -g github-oauth.github.com
}

#Crear TOKEN
function crear_token() {
	xdg-open "https://github.com/settings/tokens/new?scopes=repo,gist&description=Nuevo_token" >/dev/null 2>&1
    echo "Vete a $URL para crear un token, pulsa en 'Generate token', cópialo y pégalo aquí"
	echo "$verde Introduce el TOKEN generado, pulsa INTRO si no deseas usar ninguno"
	read -p "$verde Token →$rojo " TOKEN

	if [ -z $TOKEN ]
	then
		echo -e "$verde No se usará TOKEN$gris"
	else
		echo -e "$verde El token →$rojo $TOKEN$verde se está agregando$gris"
		git config --global github.user "$usuario_git"
		git config --global github.token "$TOKEN"
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
    read -p "Introduce el nombre completo del programador → " nombre_git

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

	echo "Creando entradas en ~/.netrc..."
    if [ -f ~/.netrc ]
	then
		mv ~/.netrc ~/.netrc.BACKUP
	else
		touch ~/.netrc
	fi
	#FIXME → Generar datos de conexión con GitHub en ~/.netrc
    #netrc "github.com" $usuario_git $TOKEN
    #netrc "api.github.com" $usuario_git $TOKEN
}
