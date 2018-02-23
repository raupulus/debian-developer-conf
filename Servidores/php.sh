#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        www.fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

############################
##        FUNCIONES       ##
############################

php_descargar() {
    echo "$VE Descargando$RO php$CL"
}

php_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO php"
}

php_instalar() {
    echo -e "$VE Instalando$RO php$CL"
}

php_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de php"
}


php_instalador() {
    php_descargar
    php_preconfiguracion
    php_instalar
    php_postconfiguracion
}
