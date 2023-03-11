#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

c_descargar() {
    echo -e "$VE Descargando$RO C$VE y$RO C++$CL"
}

c_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO C$VE y$RO C++$CL"
}

c_instalar() {
    echo -e "$VE Instalando$RO C$VE y$RO C++$CL"
    instalarSoftwareLista "$SOFTLIST/Lenguajes-Programacion/c.lst"
}

c_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO C$VE y$RO C++$CL"
}

c_instalador() {
    c_descargar
    c_preconfiguracion
    c_instalar
    c_postconfiguracion
}
