#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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

ruby_descargar() {
    echo -e "$VE Descargando$RO Ruby$CL"
}

ruby_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Ruby"
}

ruby_instalar() {
    echo -e "$VE Instalando$RO Ruby$CL"
    instalarSoftwareLista "$SOFTLIST/Lenguajes-Programacion/ruby.lst"
}

ruby_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de Ruby$CL"
}

ruby_instalador() {
    ruby_descargar
    ruby_preconfiguracion
    ruby_instalar
    ruby_postconfiguracion
}
