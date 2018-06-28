#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        http://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
## Instala y configura Geany

############################
##       FUNCIONES        ##
############################
geany_descargar() {
    echo -e "$VE Descargando$RO Geany$CL"
}

geany_preconfiguracion() {
    echo -e "$VE Instalando dependencias de$RO Geany$CL"
}

geany_instalar() {
    instalarSoftware 'geany' 'geany-plugins' 'geany-plugin-addons'
}

geany_config() {
    cat "$WORKSCRIPT/conf/home/.config/geany/geany.conf" > "$HOME/.config/geany/geany.conf"
}

geany_postconfiguracion() {
    local archivosConfiguracion=".config/geany/colorschemes \
    .config/geany/filedefs .config/geany/tags .config/geany/templates \
    .config/geany/keybindings.conf"

    ## Genero el directorio principal en el home del usuario si no existiera
    if [[ ! -d "$HOME/.config/geany" ]]; then
        mkdir -p "$HOME/.config/geany"
        geany_config
    else
        ## Pregunto si reemplazar geany.conf
        if [[ -f "$HOME/.config/geany/geany.conf" ]]; then
            echo -e "$VE ¿Reemplazar tu configuración actual de$RO Geany?$CL"
            read -p '  s/N' input
        fi

        if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
            geany_config

    fi

    ## Crea el backup y enlazar archivos de este repo
    enlazarHome "$archivosConfiguracion"
}

geany_Instalador() {
    geany_preconfiguracion
    geany_descargar
    geany_instalar
    geany_postconfiguracion
}
