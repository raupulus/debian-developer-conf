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
##        FUNCIONES       ##
############################
##
## Borra todo el contenido dentro de /var/www
##
limpiarWWW() {
    sudo systemctl stop apache2

    echo -e "$VE Cuidado, esto puede$RO BORRAR$VE algo valioso$RO"
    read -p " ¿Quieres borrar todo el directorio /var/www/? s/N → " input

    ## TODO → Controlar si es Debian, Fedora o Gentoo (Cambia la ruta).

    if [[ $DISTRO != 'debian' ]] && [[ $DISTRO != 'raspbian' ]]; then
        return 1
    fi

    if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
        sudo rm -R /var/www/*
    else
        echo -e "$VE No se borra$RO /var/www$CL"
    fi
}

##
## Añade el directorio con los archivos correspondientes para el sitio.
## $1 Nombre del directorio a copiar.
##
apache2AgregarDirectorio() {
    local site="$1"

    if [[ -z $site ]]; then
        echo "$RO No se ha pasado sitio a copiar$CL"
        return 1
    fi

    if [[ ! -d $WORKSCRIPT/Apache2/www/${site} ]]; then
        echo -e "$RO No existe el directorio para el sitio de apache a copiar$CL"
    fi

    if [[ -d "/var/www/${site}" ]]; then
        echo -e "$VE Ya existe$RO /var/www/${site}$VE, omitiendo$CL"
    fi

    echo -e "$VE Copiando contenido dentro de /var/www/${site} $CL"
    sudo cp -R $WORKSCRIPT/Apache2/www/${site}/* "/var/www/${site}"
}

##
## Agrega las configuraciones para el sitio virtual.
## $1 Recibe el nombre del archivo de configuración para el sitio virtual.
## $2 Recibe el nombre del directorio en /var/www para el sitio virtual.
##
apache2GenerarConfiguracion() {
    local conf="$1"
    local site="$2"

    if [[ -z $conf ]]; then
        echo "$RO No se ha pasado archivo de configuracion$CL"
        return 1
    fi

    if [[ ! -f "${WORKSCRIPT}/Apache2/etc/apache2/sites-available/${conf}" ]]; then
        echo "$VE No existe el archivo para el sitio de apache2 a copiar$CL"
        return 1
    fi

    if [[ -f "/etc/apache2/sites-available/${conf}" ]]; then
        echo "$VE Ya existe$RO /etc/apache2/sites-available/${conf}, omitiendo$CL"
        return 1
    fi

    if [[ -d "/var/www/${site}}" ]]; then
        echo -e "$VE Copiando archivos de configuración dentro de /etc/apache2"

        ## Copia el contenido de configuración a /etc/apache2
        sudo cp -R "${WORKSCRIPT}/Apache2/etc/apache2/sites-available/${conf}" "/etc/apache2/sites-available/${conf}"

        ## Generando directorio para logs
        if [[ ! -d "/var/log/apache2/${site}-local" ]]; then
            mkdir "/var/log/apache2/${site}-local"
        fi
    else
        echo "$VE No existe el directorio para el sitio$CL"
    fi
}

##
## Comprueba si existe el sitio virtual
## $1 Recibe el nombre del archivo de configuración para el sitio virtual.
## $2 Recibe el nombre del directorio en /var/www para el sitio virtual.
## return boolean Devuelve "true" o "false"
##
apache2ExisteSitioVirtual() {
    local conf="/etc/apache2/sites-available/${1}"
    local dirWeb="/var/www/${2}"

    ## TODO → Controlar distribución para aplicar su ruta

    if [[ -f $conf ]] && [[ -d $dirWeb ]]; then
        echo 'true'
        return 1
    fi

    echo 'false'
    return 0
}

##
## Crea una entrada en /etc/hosts para el sitio pasaddo.
## $1 Recibe el nombre del archivo hosts.
##
apache2ActivarHost() {
    echo -e "$VE Añadiendo$RO Sitio Virtual$VE al archivo$RO /etc/hosts$AM"

    ## TODO → Usar "sed" para añadir el host

    #echo '127.0.0.1 privado' | sudo tee -a '/etc/hosts'
}

##
## Asigna los permisos al sitio recibido como parámetro.
## $1 Recibe el nombre del directorio web.
##
apache2AsignarPropietario() {
    local dirWeb="$1"

    ## Cambia el dueño
    echo -e "$VE Asignando dueños$CL"

    if [[ -d "/var/www/${dirWeb}" ]]; then
        sudo chown -R www-data:www-data "/var/www/${dirWeb}"
        sudo chmod g+s -R "/var/www/${dirWeb}"
    fi
}

##
## Asigna permisos al sitio virtual y su configuración.
## $1 Recibe el nombre del directorio en /var/www para el sitio virtual.
##
apache2AsignarPermisos() {
    local dirWeb="/var/www/${1}"

    echo -e "$VE Asignando permisos a$RO Host Virtual$VE de$RO $dirWeb$CL"
    if [[ -f "/var/www/${dirWeb}/.htpasswd" ]]; then
        sudo chmod 700 "/var/www/${dirWeb}/.htpasswd"
    fi

    if [[ -f "/var/www/${dirWeb}/CMS/.htpasswd" ]]; then
        sudo chmod 700 "/var/www/${dirWeb}/CMS/.htpasswd"
    fi
}
