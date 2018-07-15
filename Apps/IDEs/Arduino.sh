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

############################
##       FUNCIONES        ##
############################

arduino_descargar() {
    descargar 'Arduino.deb' "https://????"
}

arduino_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO arduino$CL"
}

arduino_instalar() {
    echo -e "$VE Instalando$RO arduino$CL"
}

arduino_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO arduino$CL"

    echo -e "$VE Generando acceso directo$CL"
    cp "$WORKSCRIPT/Accesos_Directos/Arduino.desktop" "$HOME/.local/share/applications/"
}

arduino_instalador() {
    echo -e "$VE Comenzando instalación de$RO arduino$CL"

    arduino_preconfiguracion

    if [[ -f '/usr/bin/arduino' ]]; then
        echo -e "$VE Ya esta$RO arduino$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/arduino.deb" ]]; then
            arduino_instalar
        else
            arduino_descargar
            arduino_instalar
        fi
    fi

    arduino_postconfiguracion
}
