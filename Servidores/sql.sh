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

apache2_descargar() {
    echo "$VE Descargando$RO Apache2$CL"
}

apache2_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Apache2"
}

apache2_instalar() {
    echo -e "$VE Instalando$RO Apache2$CL"
}

apache2_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de Apache2"
}


apache2_instalador() {
    apache2_descargar
    apache2_preconfiguracion
    apache2_instalar
    apache2_postconfiguracion
}
