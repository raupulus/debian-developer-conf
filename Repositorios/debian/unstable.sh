#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Este script agrega los repositorios unstable

###########################
##       FUNCIONES       ##
###########################
##
## Añade llaves oficiales para cada repositorio
##
unstable_agregar_llaves() {
    echo -e "$VE Agregando llaves solo para repositorios$RO unstable$CL"
}

##
## Crea Backups de repositorios y añade nuevas listas
##
unstable_sources_repositorios() {
    echo -e "$VE Añadido$RO sources.list$VE y$RO sources.list.d/$VE Agregados$CL"

    crearBackup '/etc/apt/sources.list' '/etc/apt/sources.list.d/'

    if [[ ! -d '/etc/apt/sources.list.d' ]]; then
        sudo mkdir -p '/etc/apt/sources.list.d'
    fi
    sudo cp $WORKSCRIPT/Repositorios/debian/unstable/sources.list.d/* /etc/apt/sources.list.d/

    if [[ ! -d '/etc/apt/sources.list' ]]; then
        sudo rm -f '/etc/apt/sources.list'
    fi
    sudo cp "$WORKSCRIPT/Repositorios/debian/unstable/sources.list" "/etc/apt/sources.list"
}

##
## Agrega los repositorios desde su directorio "unstable"
##
unstable_download_repositorios() {
    echo -e "$VE Descargando repositorios desde scripts oficiales$CL"
}

##
## Añade todos los repositorios y llaves
##
unstable_agregar_repositorios() {
    echo -e "$VE Instalando repositorios$RO Debian unstable$CL"
    unstable_sources_repositorios
    unstable_download_repositorios
    echo -e "$VE Actualizando antes de obtener las llaves, es normal que se muestren errores$AM (Serán solucionados en el próximo paso)$CL"
    actualizarRepositorios
    unstable_agregar_llaves
    echo -e "$VE Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    actualizarRepositorios
}
