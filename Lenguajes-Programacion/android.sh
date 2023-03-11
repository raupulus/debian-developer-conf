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

android_descargar() {
    echo -e "$VE Descargando$RO Android$CL"
}

android_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Android$CL"
}

android_instalar() {
    echo -e "$VE Instalando$RO Android$CL"
    instalarSoftwareLista "$SOFTLIST/Lenguajes-Programacion/android.lst"
}

android_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO Android$CL"
}

android_instalador() {
    android_descargar
    android_preconfiguracion
    android_instalar
    android_postconfiguracion
}
