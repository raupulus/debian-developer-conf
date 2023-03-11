#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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
