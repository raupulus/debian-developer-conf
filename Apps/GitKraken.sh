#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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
## Descarga el gestor de control de versiones Gitkraken

############################
##       FUNCIONES        ##
############################

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
