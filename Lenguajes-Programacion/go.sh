#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

go_descargar() {
    echo -e "$VE Descargando$RO go$CL"
}

go_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO go$CL"
}

go_instalar() {
    echo -e "$VE Instalando$RO go$CL"
    
    instalarSoftwareLista "$SOFTLIST/Lenguajes-Programacion/go.lst"
}

go_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO go$CL"
}

go_instalador() {
    go_descargar
    go_preconfiguracion
    go_instalar
    go_postconfiguracion
}
