#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://.fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
##

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Servidores/functions.sh"
source "$WORKSCRIPT/Servidores/site-default.sh"
source "$WORKSCRIPT/Servidores/site-private.sh"
source "$WORKSCRIPT/Servidores/site-public.sh"

############################
##        FUNCIONES       ##
############################
##
## Descarga e instala la base para apache2.
##
apache2Descargar() {
    echo -e "$VE Descargando$RO Apache2$CL"
}

##
## Preconfigura apache2 antes de su instalación.
##
apache2Preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Apache2"
}

##
## Instala las dependencias para apache2.
##
apache2Dependencias() {
    echo -e "$VE Instalando$RO Apache2$CL"
    local dependencias="apache2 libapache2-mod-perl2 libapache2-mod-php libapache2-mod-python"

    instalarSoftware "$dependencias"
}

##
## Asigna propietario a los sitios virtuales y su configuración.
##
apache2Propietarios() {
    ## Cambia el dueño
    echo -e "$VE Asignando dueños$CL"
    sudo chown root:root '/etc/apache2/ports.conf'

    ## Agrega el usuario al grupo www-data
    echo -e "$VE Añadiendo el usuario al grupo$RO www-data"
    sudo adduser "$USER" 'www-data'

    ## Cada archivo/directorio creado tomará el grupo www-data
    if [[ -d "/home/$USER/GIT" ]]; then
        sudo chown -R "$USER":www-data "/home/$USER/GIT"
        sudo chmod g+s -R "/home/$USER/GIT"
    fi

    if [[ -d "/home/$USER/git" ]]; then
        sudo chown -R "$USER":www-data "/home/$USER/git"
        sudo chmod g+s -R "/home/$USER/git"
    fi
}

##
## Asigna los permisos para los sitios virtuales y la configuración.
##
apache2Permisos() {
    echo -e "$VE Asignando permisos$RO Configuración$CL"
    sudo chmod 750 '/etc/apache2/ports.conf'
    sudo chmod 750 '/etc/apache2/apache2.conf'

    echo -e "$VE Asignando permisos a$RO Hosts Virtuales$CL"
    sudo chmod ug+rw -R /var/www/*
    sudo chmod 700 '/var/www/.htpasswd'
    sudo chmod 755 '/etc/apache2/'
    sudo chmod 755 -R '/etc/apache2/sites-available' '/etc/apache2/sites-enabled'
}

##
## Habilita módulos de apache2.
##
apache2Activar_modulos() {
    echo -e "$VE Activando módulos$RO"
    sudo a2enmod rewrite
    sudo a2enmod ssl
}

##
## Deshabilita módulos de apache2
##
apache2Desactivar_modulos() {
    echo -e "$VE Desactivando módulos$RO"
    sudo a2dismod php5
}

##
## Aplica configuraciones tras instalar apache2.
##
apache2Postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de Apache2"

    ## TODO → Controlar distribución, la ruta de destino cambia.
    sudo cp "$WORKSCRIPT/Apache2/etc/apache2/ports.conf" '/etc/apache2/apache2.conf'
}

##
## Agrega y habilita certificado ssl y módulo.
##
apache2Ssl() {
    ## Instalar módulo SSL
    sudo a2enmod ssl
    reiniciarServicio apache2

    ## Comprobar que está activo y abierto el puerto
    netstat -nl | grep 443
    sudo iptables -nL | grep 443

    ## Crear certificado autofirmado
    if [[ ! -d /etc/apache2/ssl ]]; then
        sudo mkdir /etc/apache2/ssl
    fi

    sudo chmod 700 -R /etc/apache2/ssl

    ## Genero certificados para localhost en caso de no existir
    local existe=$(sudo ls /etc/apache2/ssl/localhost.key)
    local existe1=$(sudo ls /etc/apache2/ssl/localhost.csr)
    local existe2=$(sudo ls /etc/apache2/ssl/localhost.crt)
    if [[ ! "$existe" = '/etc/apache2/ssl/localhost.key' ]]; then
        if [[ ! "$existe1" = '/etc/apache2/ssl/localhost.csr' ]]; then
            sudo rm /etc/apache2/ssl/localhost.csr
        fi

        if [[ ! "$existe2" = '/etc/apache2/ssl/localhost.crt' ]]; then
            sudo rm /etc/apache2/ssl/localhost.crt
        fi

        sudo openssl genrsa -des3 -out /etc/apache2/ssl/localhost.key 4096
        sudo openssl req -new -key \
            /etc/apache2/ssl/localhost.key \
            -out /etc/apache2/ssl/localhost.csr

        sudo openssl x509 -req -days 5000 \
            -in /etc/apache2/ssl/localhost.csr \
            -signkey /etc/apache2/ssl/localhost.key \
            -out /etc/apache2/ssl/localhost.crt


        ## Muevo el .key para quitar que pida la contraseña
        sudo mv /etc/apache2/ssl/localhost.key /etc/apache2/ssl/localhostBACKUP.key
        sudo openssl rsa -in /etc/apache2/ssl/localhostBACKUP.key -out /etc/apache2/ssl/localhost.key
        sudo rm /etc/apache2/ssl/localhostBACKUP.key
    fi

    sudo chmod 600 -R /etc/apache2/ssl/
}

##
## Agrega configuraciones de seguridad y permisos para los sitios virtuales.
##
apache2DefaultSiteSecurity() {
    ## Crear archivo de usuario con permisos para directorios restringidos
    echo -e "$VE Creando usuario con permisos en apache"

    while [[ -z "$input_user" ]]; do
        read -p "Nombre de usuario para acceder a los sitios web privado → " input_user
    done

    echo -e "$VE Introduce la contraseña para los sitios web privados:$RO"
    sudo htpasswd -c /var/www/.htpasswd $input_user
}

##
## Borrar contenido de /var/www
##
apache2LimpiarSites() {
    sudo systemctl stop apache2
    echo -e "$VE Cuidado, esto puede$RO BORRAR$VE algo valioso$RO"
    read -p " ¿Quieres borrar todo el directorio /var/www/? s/N → " input
    if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
        sudo rm -R /var/www/*
    else
        echo -e "$VE No se borra$RO /var/www$CL"
    fi
}

##
## Generar enlaces:
## ~/web a /var/www
## ~/git a /var/www/private/git
##
apache2GenerarEnlaces() {
    local rutaEnlaceWeb='/var/www'

    ## Creo enlace al directorio web.
    if [[ ! -h "/home/$USER/web" ]] ||
       [[ ! -d "$rutaEnlaceWeb" ]]; then
        echo -e "$VE Creando enlace desde$RO ${HOME$V}/web$VE hasta$RO $rutaEnlaceWeb$CL"

        sudo ln -s "$rutaEnlaceWeb" "/home/$USER/web"
        sudo chown -R "$USER:www-data" "/home/$USER/web"
    fi

    ## Creo enlace a repositorios "git" en zona privada.
    if [[ -d "$HOME/git" ]] &&
       [[ "$ENV" = 'dev' ]] &&
       [[ -d "${rutaEnlaceWeb}/private" ]] &&
       [[ ! -h "${rutaEnlaceWeb}/private/git" ]];
    then
        echo -e "$VE Creando enlace desde$RO ${HOME$V}/git$VE hasta$RO /var/www/private$CL"
        sudo ln -s "$HOME/git" '/var/www/private/git'
    elif [[ -d "$HOME/GIT" ]] &&
         [[ "$ENV" = 'dev' ]] &&
         [[ -d "${rutaEnlaceWeb}/private" ]] &&
         [[ ! -h "${rutaEnlaceWeb}/private/git" ]];
    then
        echo -e "$VE Creando enlace desde$RO ${HOME$V}/GIT$VE hasta$RO /var/www/private$CL"
        sudo ln -s "$HOME/GIT" '/var/www/private/git'
        sudo ln -s "$HOME/GIT" "$HOME/git"
    fi
}

apache2Instalar() {
    local rutaEnlaceWeb='/var/www'

    apache2LimpiarSites
    apache2Descargar
    apache2Preconfiguracion
    apache2Dependencias
    apache2Activar_modulos
    apache2Desactivar_modulos
    apache2Ssl

    if [[ ! -f "${rutaEnlaceWeb}/.htpasswd" ]]; then
        apache2DefaultSiteSecurity
    fi

    ## Habilito sitios virtuales.
    apacheDefaultSiteCreate
    apachePublicSiteCreate

    if [[ "$ENV" = 'dev' ]]; then
        apachePrivateSiteCreate
    fi

    ## Genero enlaces.
    apache2GenerarEnlaces

    ## Propietario y permisos
    apache2Propietarios
    apache2Permisos

    ## Reiniciar servidor Apache para aplicar configuración
    reiniciarServicio apache2
}
