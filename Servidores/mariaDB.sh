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

mariadb_descargar() {
    echo "$VE Descargando$RO mariadb$CL"
}

mariadb_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO mariadb"
}

mariadb_instalar() {
    echo -e "$VE Instalando$RO mariadb$CL"
}

mariadb_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de mariadb"
}


mariadb_instalador() {
    mariadb_descargar
    mariadb_preconfiguracion
    mariadb_instalar
    mariadb_postconfiguracion
}
