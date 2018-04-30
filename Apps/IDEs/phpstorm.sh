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
##
## Descarga PhpStorm de su web oficial
## $1 string Recibe el nombre de la versión
##
phpstorm_descargar() {
    descargar 'PhpStorm' "https://download.jetbrains.com/webide/${1}.tar.gz"
}

phpstorm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO PhpStorm$CL"
    if [[ -d "$HOME/.local/opt/phpstorm" ]]; then
        rm -Rf "$HOME/.local/opt/phpstorm"
    fi

    if [[ -f "$HOME/.local/bin/phpstorm" ]]; then
        rm -f "$HOME/.local/bin/phpstorm"
    fi

    if [[ -f "$HOME/.local/share/applications/phpstorm.desktop" ]]; then
        rm -f "$HOME/.local/share/applications/phpstorm.desktop"
    fi
}

##
## Instala PhpStorm para el usuario dentro de ~/.local/opt
## $1 string Recibe el nombre de la versión
##
phpstorm_instalar() {
    echo -e "$VE Preparando para instalar$RO PhpStorm$CL"
    mv "$WORKSCRIPT/tmp/$1" "$HOME/.local/opt/phpstorm"
}

phpstorm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO PhpStorm$CL"

    echo -e "$VE Generando acceso directo$CL"
    rm -f "$HOME/.local/share/applications/phpstorm.desktop"
    cp "$WORKSCRIPT/Accesos_Directos/phpstorm.desktop" "$HOME/.local/share/applications/"
}

phpstorm_instalador() {
    local version='PhpStorm-2018.1.2'

    echo -e "$VE Comenzando instalación de$RO PhpStorm$CL"

    phpstorm_preconfiguracion "$version"

    if [[ -f "$HOME/.local/bin/phpstorm" ]] &&
       [[ -d "$HOME/.local/opt/phpstorm" ]]
    then
        echo -e "$VE Ya esta$RO PhpStorm$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/${version}.tar.gz" ]]; then
            phpstorm_instalar "$version" || rm -Rf "$WORKSCRIPT/tmp/${version}.tar.gz"
        else
            phpstorm_descargar "$version"
            phpstorm_instalar "$version"
        fi
    fi

    phpstorm_postconfiguracion "$version"
}
