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
## Contiene las rutas hacia directorios de configuraciones que pueden variar
## entre distribuciones.

############################
##        FUNCIONES       ##
############################
##
## Configura las rutas a directorios de apache.
##
routesApache2() {
    if [[ "$DISTRO" = 'debian' ]] || [[ "$DISTRO" = 'raspbian' ]]; then
        echo -e "$VE Configurando directorios apache para $DISTRO$CL"
        APACHECONF='/etc/apache2'
        DIRWEBLOG='/var/log/apache2'
        DIRWEB='/var/www'
        APACHESITES="${APACHECONF}/sites-available"
        APACHESITESENABLED="${APACHECONF}/sites-enabled"
        APACHEPORTSCONF="${APACHECONF}/ports.conf"
        APACHEAPACHE2CONF="${APACHECONF}/apache2.conf"
    elif [[ "$DISTRO" = 'fedora' ]]; then
        echo -e "$VE Configurando directorios apache para $DISTRO$CL"
        APACHECONF='/etc/httpd'
        DIRWEBLOG='/var/log/httpd'
        DIRWEB='/var/www'
        APACHESITES="${APACHECONF}/conf.d/sites-available"
        APACHESITESENABLED="${APACHECONF}/conf.d"
        ##APACHEPORTSCONF="${APACHECONF}/ports.conf"
        ##APACHEAPACHE2CONF="${APACHECONF}/apache2.conf"

        if [[ ! -d "$APACHESITES" ]]; then
            mkdir -p $APACHESITES
        fi
    elif [[ "$DISTRO" = 'gentoo' ]]; then
        echo -e "$VE Configurando directorios apache para $DISTRO$CL"
    else
        echo -e "$VE No se puede configurar rutas de apache$CL"
        exit 1
    fi
}

setAllRoutes() {
    echo -e "$VE Configurando rutas de directorios$CL"

    routesApache2
}
