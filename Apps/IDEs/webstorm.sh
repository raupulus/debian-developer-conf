#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################
## Instala el IDE Webstorm

############################
##       FUNCIONES        ##
############################
##
## Descarga WebStorm de su web oficial
## $1 string Recibe el nombre de la versión
##
webstorm_descargar() {
    descargar "${1}.tar.gz" "https://download.jetbrains.com/webstorm/${1}.tar.gz"
}

webstorm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO WebStorm$CL"
    if [[ -d "$HOME/.local/opt/webstorm" ]]; then
        rm -Rf "$HOME/.local/opt/webstorm"
    fi

    if [[ -f "$HOME/.local/bin/webstorm" ]]; then
        rm -f "$HOME/.local/bin/webstorm"
    fi

    if [[ -f "$HOME/.local/share/applications/webstorm.desktop" ]]; then
        rm -f "$HOME/.local/share/applications/webstorm.desktop"
    fi
}

##
## Instala WebStorm para el usuario dentro de ~/.local/opt
## $1 string Recibe el nombre de la versión
##
webstorm_instalar() {
    echo -e "$VE Preparando para instalar$RO WebStorm$CL"
    echo -e "$VE Extrayendo IDE$CL"
    cd "$WORKSCRIPT/tmp/" || return 0
    tar -zxf "${1}.tar.gz" 2>> /dev/null
    local directorio="$(ls | grep -E ^WebStorm.+[^\.tar\.gz]$)"
    mv "$WORKSCRIPT/tmp/$directorio" "$HOME/.local/opt/webstorm"
    cd "$WORKSCRIPT" || exit 1
}

webstorm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO WebStorm$CL"

    echo -e "$VE Generando acceso directo$CL"
    rm -f "$HOME/.local/share/applications/webstorm.desktop"
    cp "$WORKSCRIPT/Accesos_Directos/webstorm.desktop" "$HOME/.local/share/applications/"

    echo -e "$VE Generando comando$RO webstorm$CL"
    ln -s "$HOME/.local/opt/webstorm/bin/webstorm.sh" "$HOME/.local/bin/webstorm"
}

webstorm_instalador() {
    local version='WebStorm-2020.3'

    echo -e "$VE Comenzando instalación de$RO WebStorm$CL"

    webstorm_preconfiguracion "$version"

    if [[ -f "$HOME/.local/bin/webstorm" ]] &&
       [[ -d "$HOME/.local/opt/webstorm" ]]
    then
        echo -e "$VE Ya esta$RO WebStorm$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/${version}.tar.gz" ]]; then
            webstorm_instalar "$version" || rm -Rf "$WORKSCRIPT/tmp/${version}.tar.gz"
        else
            webstorm_descargar "$version"
            webstorm_instalar "$version"
        fi
    fi

    webstorm_postconfiguracion "$version"
}
