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

DIR_ACTUAL=$(echo $PWD)
nombre_git=""
usuario_git=""
correo_git=""
TOKEN=""
TOKEN_GITLAB=""

# TODO → Refactorizar y dejar configuración independiente para github y gitlab
# TODO → Plantear integración con Bitbucket en el archivo git y su token
# TODO → Archivo ~/.netrc modificar con "sed"

function datos_input() {
    #Se entiende que tiene el mismo usuario para GitHub y para GitLab
    read -p "Introduce el usuario de GitHub y GitLab → " usuario_git
    read -p "Introduce el correo electronico → " correo_git
}

function gpg_git() {
    echo -e "$verde Configurando GPG para GIT$gris"

    # Listar claves actuales, si hubiera instaladas en el equipo
    echo -e "$verde Las claves instaladas en el equipo son las siguientes:$amarillo"
    gpg --list-keys

    # Usar clave o crear una
    echo -e "$verde ¿Usar una clave existente?$rojo"
    read -p '  s/N  → ' input

    #if [ $input = 's' ] || [ $input = 'S' ] || [ $input = 'y' ] || [ $input = 'Y' ]
    #then
    #echo -e "$verde Se creará una clave GPG única nueva:"
    # TODO → [comando] → Crear clave GPG fuerte
    #echo -e "$verde Copia y pega la clave GPG en la siguiente entrada$rojo"
    #read -p '  s/N  → ' CLAVE_GPG
    #git config --global user.signingkey CLAVE_GPG
    #fi

    # Habilitar GPG en GIT
    git config --global gpg.program gpg


    # Firmar commits por defecto
    #echo -e "$verde ¿Quieres firmar commits automáticamente por defecto?$amarillo"
    #read -p '  s/N  → ' input
    #if [ $input = 's' ] || [ $input = 'S' ] || [ $input = 'y' ] || [ $input = 'Y' ]
    #then
    #git config --global commit.gpgsign true  # Firmar commit por defecto
    fi
}

#Configurar el usuario GIT local
function configurar_git() {
    cd #Cambio al directorio home para que no de problemas GIT
    git config --global user.name "$nombre_git"
    git config --global user.email "$correo_git"
    git config --global core.editor vim
    git config --global color.ui true
    git config --global gui.encoding utf-8

    # Preguntar si se desea configurar GPG
    echo -e "$verde ¿Quieres configurar una clave GPG para firmar?$yellow"
    read -p 'Introduce una opción y/N → ' input
    if [ -n $input ] || [ $input = 'n' ] || [ $input = 'N' ]
    then
        # LLamada a la función para configurar GPG
        gpg_git
    fi

    #Reparar finales de linea que mete la mierda de windows CRLF to LF
    git config --global core.autocrlf input

    cd $DIR_ACTUAL
}

#Configura el usuario en GITHUB
function configurar_github() {
    cd
    git config --global github.name "$nombre_git"
    git config --global github.user "$usuario_git"
    #TODO →   github-oauth.github.com is not defined.
    #TODO → composer config -g github-oauth.github.com

    cd $DIR_ACTUAL
}

#Configurar el usuario en gitlab
function configurar_gitlab() {
    cd
    git config --global gitlab.name "$nombre_git"
    git config --global gitlab.user "$usuario_git"
    cd $DIR_ACTUAL
}

function configurar_netrc() {
    if [ -f ~/.netrc ]
    then
        mv ~/.netrc ~/.netrc.BACKUP
    else
        touch ~/.netrc
    fi

    echo "machine github.com" > ~/.netrc
    echo "  login $usuario_git" >> ~/.netrc
    echo "  password $TOKEN" >> ~/.netrc

    echo "machine api.github.com" >> ~/.netrc
    echo "  login $usuario_git" >> ~/.netrc
    echo "  password $TOKEN" >> ~/.netrc

    echo "machine gitlab.com" >> ~/.netrc
    echo "  login $usuario_git" >> ~/.netrc
    echo "  password $TOKEN_GITLAB" >> ~/.netrc

    echo "machine api.gitlab.com" >> ~/.netrc
    echo "  login $usuario_git" >> ~/.netrc
    echo "  password $TOKEN_GITLAB" >> ~/.netrc
}

#Crear TOKEN
function crear_token() {
    cd
    #Generando TOKEN para GitHub
    xdg-open "https://github.com/settings/tokens/new?scopes=repo,gist&description=Nuevo_token" >/dev/null 2>&1
    echo -e "$verde Vete a$rojo $URL$verde para crear un token, pulsa en 'Generate token', cópialo y pégalo aquí"
    echo -e "$verde Introduce el TOKEN de GitHub generado, pulsa$amarillo INTRO$verde si no deseas usar ninguno$gris"
    read -p " Token → " TOKEN

    if [ -z $TOKEN ]
    then
        echo -e "$verde No se usará TOKEN para GitHub$gris"
    else
        echo -e "$verde El token →$rojo $TOKEN$verde para GitHub se está agregando$gris"
        git config --global github.token $TOKEN
    fi

    #Generando TOKEN para GitLab
    xdg-open "https://gitlab.com/profile/account" >/dev/null 2>&1
    echo -e "$verde Genera un nuevo token en la URL que se abrirá en el navegador"
    echo -e "$verde Introduce el TOKEN de GitLab generado, pulsa$amarillo INTRO$verde si no deseas usar ninguno$gris"
    read -p " Token → " TOKEN_GITLAB

    if [ -z $TOKEN_GITLAB ]
    then
        echo -e "$verde No se usará TOKEN para GitLab$gris"
    else
        echo -e "$verde El token →$rojo $TOKEN_GITLAB$verde para GitLab se está agregando$gris"
        git config --global gitlab.token $TOKEN_GITLAB
    fi

    cd $DIR_ACTUAL
}

#Crear Alias dentro de GIT
function crear_git_alias() {
    echo -e "$verde Alias para el comando$rojo git lg$gris"
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

    echo -e "$verde Alias para el comando$rojo git hist$gris"
    git config --global alias.hist "log --graph --date-order --date=short --pretty=format:'%C(bold blue)%h%d %C(bold red)(%cd) %C(bold yellow)%s %C(bold blue)%ce %C(reset)%C(green)%cr'"

    echo -e "$verde Alias para el comando$rojo git his$gris"
    git config --global alias.his "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"

    git config --global push.default simple
}

function configuracion_git() {
    cd

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
    configurar_gitlab
    crear_token
    configurar_netrc
    crear_git_alias

    cd $DIR_ACTUAL
}
