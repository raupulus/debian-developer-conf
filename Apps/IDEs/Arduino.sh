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
## Descarga el IDE de Arduino desde la página web en su última versión estable

############################
##       FUNCIONES        ##
############################

arduino_descargar() {
    local version="${1}-linux64"
    descargar "${version}.tar.xz" "https://downloads.arduino.cc/${version}.tar.xz"
}

arduino_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO arduino$CL"
    if [[ -d "$HOME/.local/opt/arduino" ]]; then
        rm -Rf "$HOME/.local/opt/arduino"
    fi

    if [[ -h "$HOME/.local/bin/arduino" ]]; then
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

    tar -Jxvf "${version}-linux64.tar.xz" 2>> /dev/null

    if [[ -d "$WORKSCRIPT/tmp/$version" ]]; then
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
    local version='arduino-1.8.10'

    arduino_preconfiguracion "$version"

    if [[ -f "$HOME/.local/bin/arduino" ]] &&
       [[ -d "$HOME/.local/opt/arduino" ]]
    then
        echo -e "$VE Ya esta$RO arduino$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/${version}-linux64.tar.xz" ]]; then
            arduino_instalar "$version" || rm -Rf "$WORKSCRIPT/tmp/${version}-linux64.tar.xz"
        else
            arduino_descargar "$version"
            arduino_instalar "$version"
        fi
    fi

    arduino_postconfiguracion "$version"
}
