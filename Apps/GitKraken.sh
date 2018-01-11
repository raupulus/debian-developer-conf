#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################
gitkraken_descargar() {
    descargar "gitkraken.deb" "https://release.gitkraken.com/linux/gitkraken-amd64.deb"
}

gitkraken_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO GitKraken$CL"
}

gitkraken_instalar() {
    echo -e "$VE Instalando$RO GitKraken$CL"
    sudo dpkg -i "$WORKSCRIPT/tmp/gitkraken.deb" && sudo apt install -f -y
}

gitkraken_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO GitKraken$CL"
}

gitkraken_instalador() {
    echo -e "$VE Comenzando instalación de$RO GitKraken$CL"

    gitkraken_preconfiguracion

    if [[ -f '/usr/bin/gitkraken' ]]; then
        echo -e "$VE Ya esta$RO Gitkraken$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/gitkraken.deb" ]]; then
            gitkraken_instalar
        else
            gitkraken_descargar
            gitkraken_instalar
        fi

        ## Si falla la instalación se rellama la función tras limpiar
        if [[ ! -f '/usr/bin/gitkraken' ]]; then
            rm -f "$WORKSCRIPT/tmp/gitkraken.deb"
            gitkraken_descargar
            gitkraken_instalar
        fi
    fi

    gitkraken_postconfiguracion
}
