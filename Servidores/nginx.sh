#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

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
    instalarSoftwareLista "${SOFTLIST}/Servidores/nginx.lst"
}

nginx_after_install() {
    echo -e "$VE Generando Post-Configuraciones de$RO Nginx$CL"
}

nginx_installer() {
    nginx_download
    nginx_before_install
    nginx_install
    nginx_after_install
}
