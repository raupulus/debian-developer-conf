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

sqlite_descargar() {
    echo -e "$VE Descargando$RO sqlite$CL"
}

sqlite_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO sqlite$CL"
}

sqlite_instalar() {
    echo -e "$VE Instalando$RO sqlite$CL"
    instalarSoftwareLista "${SOFTLIST}/servers/sqlite.lst"
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
