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
