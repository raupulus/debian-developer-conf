#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Contiene las rutas hacia directorios de configuraciones que pueden variar
## entre distribuciones.

############################
##        FUNCTIONS       ##
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
        APACHEMODS="${APACHECONF}/mods-available"
        APACHEMODSENABLED="${APACHECONF}/mods-enabled"
    elif [[ "$DISTRO" = 'fedora' ]]; then
        echo -e "$VE Configurando directorios apache para $DISTRO$CL"
        APACHECONF='/etc/httpd'
        DIRWEBLOG='/var/log/httpd'
        DIRWEB='/var/www'
        APACHESITES="${APACHECONF}/conf.d/sites-available"
        APACHESITESENABLED="${APACHECONF}/conf.d"

        # TODO → Estas rutas hay que verificarlas
        APACHEPORTSCONF="${APACHECONF}/ports.conf"
        APACHEAPACHE2CONF="${APACHECONF}/apache2.conf"
        APACHEMODS="${APACHECONF}/mods-available"
        APACHEMODSENABLED="${APACHECONF}/mods-enabled"

        if [[ ! -d "$APACHESITES" ]]; then
            sudo mkdir -p $APACHESITES
            sudo chmod 750 $APACHESITES
            sudo chown :www-data $APACHESITES
        fi

        if [[ ! -d "$APACHEMODS" ]]; then
            sudo mkdir -p $APACHEMODS
            sudo chmod 750 $APACHEMODS
            sudo chown :www-data $APACHEMODS
        fi
    elif [[ "$DISTRO" = 'gentoo' ]]; then
        echo -e "$VE Configurando directorios apache para $DISTRO$CL"
    elif [[ "$DISTRO" = 'macos' ]]; then
        echo -e "$VE Configurando directorios apache para $DISTRO$CL"
        APACHECONF='/opt/homebrew/etc/httpd'
        DIRWEBLOG='/var/log/apache2'
        DIRWEB="/Users/${USER}/www"
        APACHESITES="${APACHECONF}/extra/httpd-vhosts.conf"
        APACHESITESENABLED=""
        APACHEPORTSCONF="${APACHECONF}/ports.conf"
        APACHEAPACHE2CONF="${APACHECONF}/httpd.conf"
        APACHEMODS=""
        APACHEMODSENABLED=""
    else
        echo -e "$VE No se puede configurar rutas de apache$CL"
        exit 1
    fi
}

setAllRoutes() {
    echo -e "$VE Configurando rutas de directorios$CL"

    routesApache2
}
