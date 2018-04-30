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
## Instala el IDE PhpStorm

############################
##       FUNCIONES        ##
############################

phpstorm_descargar() {
    descargar 'Web' "https://download.jetbrains.com/webide/PhpStorm-2018.1.2.tar.gz"
}

phpstorm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO PhpStorm$CL"
}

phpstorm_instalar() {
    echo -e "$VE Preparando para instalar$RO PhpStorm$CL"
}

phpstorm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO PhpStorm$CL"

    echo -e "$VE Generando acceso directo$CL"
    cp "$WORKSCRIPT/Accesos_Directos/phpstorm.desktop" "$HOME/.local/share/applications/"
}

phpstorm_instalador() {
    echo -e "$VE Comenzando instalación de$RO PhpStorm$CL"

    phpstorm_preconfiguracion

    if [[ -f '/usr/bin/phpstorm' ]]; then
        echo -e "$VE Ya esta$RO PhpStorm$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/PhpStorm.deb" ]]; then
            phpstorm_instalar || rm -Rf "$WORKSCRIPT/tmp/PhpStorm.deb"
        else
            phpstorm_descargar
            phpstorm_instalar
        fi
    fi

    phpstorm_postconfiguracion
}
