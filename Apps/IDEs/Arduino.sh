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
## Descarga el IDE de Arduino desde la página web en su última versión estable

############################
##       FUNCIONES        ##
############################

arduino_descargar() {
    local version=$1
    descargar "$version" "https://downloads.arduino.cc/${version}.tar.xz"
}

arduino_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO arduino$CL"
    if [[ -d "$HOME/.local/opt/arduino" ]]; then
        rm -Rf "$HOME/.local/opt/arduino"
    fi

    if [[ -f "$HOME/.local/bin/arduino" ]]; then
        rm -f "$HOME/.local/bin/arduino"
    fi

    if [[ -f "$HOME/.local/share/applications/Arduino-IDE.desktop" ]]; then
        rm -f "$HOME/.local/share/applications/Arduino-IDE.desktop"
    fi
}

arduino_instalar() {
    echo -e "$VE Instalando$RO arduino$CL"
    echo -e "$VE Extrayendo IDE$CL"

    local version="$1"

    cd "$WORKSCRIPT/tmp/" || return 0

    tar -Jxvf "${version}.tar.xz" 2>> /dev/null

    if [[ -d $WORKSCRIPT/tmp/$version ]]; then
        mv "$WORKSCRIPT/tmp/$version" "$HOME/.local/opt/arduino"
    fi

    cd "$WORKSCRIPT" || exit 1
}

arduino_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO arduino$CL"

    echo -e "$VE Generando acceso directo$CL"
    rm -f "$HOME/.local/share/applications/Arduino-IDE.desktop"
    cp "$WORKSCRIPT/Accesos_Directos/Arduino-IDE.desktop" "$HOME/.local/share/applications/"

    echo -e "$VE Generando comando$RO arduino$CL"
    ln -s "$HOME/.local/opt/arduino/arduino" "$HOME/.local/bin/arduino"
}

arduino_instalador() {
    echo -e "$VE Comenzando instalación de$RO arduino$CL"
    local version='arduino-1.8.5-linux64'

    arduino_preconfiguracion "$version"

    if [[ -f "$HOME/.local/bin/arduino" ]] &&
       [[ -d "$HOME/.local/opt/arduino" ]]
    then
        echo -e "$VE Ya esta$RO arduino$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/$version" ]]; then
            arduino_instalar "$version" || rm -Rf "$WORKSCRIPT/tmp/${version}.tar.xz"
        else
            arduino_descargar "$version"
            arduino_instalar "$version"
        fi
    fi

    arduino_postconfiguracion "$version"
}
