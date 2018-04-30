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
## Instala el IDE Webstorm

############################
##       FUNCIONES        ##
############################


webstorm_descargar() {
    descargar 'Web' "https://download.jetbrains.com/webstorm/WebStorm-2018.1.2.tar.gz"
}

webstorm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO WebStorm$CL"
}

webstorm_instalar() {
    echo -e "$VE Preparando para instalar$RO WebStorm$CL"
}

webstorm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO WebStorm$CL"

    echo -e "$VE Generando acceso directo$CL"
    cp "$WORKSCRIPT/Accesos_Directos/webstorm.desktop" "$HOME/.local/share/applications/"
}

webstorm_instalador() {
    echo -e "$VE Comenzando instalación de$RO WebStorm$CL"

    webstorm_preconfiguracion

    if [[ -f '/usr/bin/webstorm' ]]; then
        echo -e "$VE Ya esta$RO WebStorm$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/WebStorm.deb" ]]; then
            webstorm_instalar || rm -Rf "$WORKSCRIPT/tmp/WebStorm.deb"
        else
            webstorm_descargar
            webstorm_instalar
        fi
    fi

    webstorm_postconfiguracion
}
