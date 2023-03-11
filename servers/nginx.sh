#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################

nginx_download() {
    echo -e "$VE Descargando$RO Nginx$CL"
}

nginx_before_install() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Nginx$CL"
}

nginx_install() {
    echo -e "$VE Instalando$RO Nginx$CL"
    instalarSoftwareLista "${SOFTLIST}/servers/nginx.lst"
}

nginx_after_install() {
    echo -e "$VE Generando Post-Configuraciones de$RO Nginx$CL"

    ## Creo almacenamiento para aplicaciones
    if [[ ! -d '/var/www/storage' ]]; then
        sudo mkdir '/var/www/storage'
        sudo chown www-data:www-data -R '/var/www/storage'
        sudo chmod 770 -R '/var/www/storage'
        sudo chmod ug+s -R '/var/www/storage'
        sudo umask 117 -R '/var/www/storage'
    fi

    ## Creo lugar para sitios públicos
    if [[ ! -d '/var/www/public' ]]; then
        sudo mkdir '/var/www/public'
        sudo chown www-data:www-data -R '/var/www/public'
        sudo chmod 770 -R '/var/www/public'
        sudo chmod ug+s -R '/var/www/public'
        sudo umask 117 -R '/var/www/public'
    fi

    ## Creo lugar para sitios privados
    if [[ ! -d '/var/www/private' ]]; then
        sudo mkdir '/var/www/private'
        sudo chown www-data:www-data -R '/var/www/private'
        sudo chmod 770 -R '/var/www/private'
        sudo chmod ug+s -R '/var/www/private'
        sudo umask 117 -R '/var/www/private'
    fi
}

nginx_installer() {
    nginx_download
    nginx_before_install
    nginx_install
    nginx_after_install
}
