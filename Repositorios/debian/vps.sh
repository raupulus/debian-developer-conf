#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Este script agrega los repositorios estables y algunos más de forma segura
## y con sus llaves correspondientes preparadas para un vps genérico.
## Por motivos de seguridad se dejarán los repositorios listos para usar en
## el sistema pero comentados, es decir, los que considero que depende del
## usuario activarlos y usarlo bajo su responsabilidad están comentados.

###########################
##       FUNCIONES       ##
###########################
##
## Añade llaves oficiales para cada repositorio
##
vps_add_keys() {
    echo -e "$VE Agregando llaves solo para repositorios$RO VPS$CL"
}

##
## Crea Backups de repositorios y añade nuevas listas
##
vps_sources_repositorios() {
    echo -e "$VE Añadido$RO sources.list$VE y$RO sources.list.d/$VE Agregados$CL"

    crearBackup '/etc/apt/sources.list' '/etc/apt/sources.list.d/'

    if [[ ! -d '/etc/apt/sources.list.d' ]]; then
        sudo mkdir -p '/etc/apt/sources.list.d'
    fi
    sudo cp $WORKSCRIPT/Repositorios/debian/vps/sources.list.d/* /etc/apt/sources.list.d/

    if [[ ! -d '/etc/apt/sources.list' ]]; then
        sudo rm -f '/etc/apt/sources.list'
    fi

    sudo cp "$WORKSCRIPT/Repositorios/debian/vps/sources.list" "/etc/apt/sources.list"
}

##
## Agrega los repositorios desde su directorio "stable"
##
vps_download_repositories() {
    echo -e "$VE Descargando repositorios desde scripts oficiales$CL"
}

##
## Añade todos los repositorios y llaves
##
vps_add_repositories() {
    echo -e "$VE Instalando repositorios$RO Debian Stable$CL"
    vps_sources_repositorios
    vps_download_repositories
    echo -e "$VE Actualizando antes de obtener las llaves, es normal que se muestren errores$AM (Serán solucionados en el próximo paso)$CL"
    actualizarRepositorios
    vps_add_keys
    echo -e "$VE Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    actualizarRepositorios
}
