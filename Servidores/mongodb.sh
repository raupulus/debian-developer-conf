#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

mongodb_descargar() {
    echo -e "$VE Descargando$RO mongodb$CL"
}

mongodb_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO mongodb$CL"

    sudo groupadd mongodb
    sudo usermod -a -G mongodb "$USER"
}

mongodb_instalar() {
    echo -e "$VE Instalando$RO mongodb$CL"
    instalarSoftwareLista "${SOFTLIST}/Servidores/mongodb.lst"
}

mongodb_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO mongodb$CL"
}

mongodb_instalador() {
    mongodb_descargar
    mongodb_preconfiguracion
    mongodb_instalar
    mongodb_postconfiguracion
}
