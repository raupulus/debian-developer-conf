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

sqlite_descargar() {
    echo -e "$VE Descargando$RO sqlite$CL"
}

sqlite_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO sqlite$CL"
}

sqlite_instalar() {
    echo -e "$VE Instalando$RO sqlite$CL"
    instalarSoftwareLista "${SOFTLIST}/Servidores/sqlite.lst"
}

sqlite_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO sqlite$CL"
}

sqlite_instalador() {
    sqlite_descargar
    sqlite_preconfiguracion
    sqlite_instalar
    sqlite_postconfiguracion
}
