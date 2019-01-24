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
        echo "$VE No existe el directorio para el sitio de apache a copiar$CL"
    fi

    if [[ -d "/var/www/${site}" ]]; then
        echo "$VE Ya existe$RO /var/www/${site}$VE, omitiendo$CL"
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

    ## Copia el contenido de configuración a /etc/apache2
    if [[ -d "/var/www/${site}}" ]]; then
        echo -e "$VE Copiando archivos de configuración dentro de /etc/apache2"
        sudo cp -R "${WORKSCRIPT}/Apache2/etc/apache2/sites-available/${conf}" "/etc/apache2/sites-available/${conf}"
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
