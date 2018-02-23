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

python_descargar() {
    echo "$VE Descargando$RO python$CL"
}

python_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO python"
}

python_instalar() {
    echo -e "$VE Instalando$RO python$CL"
}

python_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de python"
}


python_instalador() {
    python_descargar
    python_preconfiguracion
    python_instalar
    python_postconfiguracion
}
