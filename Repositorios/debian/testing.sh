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
## Este script agrega los repositorios testing y algunos más de forma segura
## y con sus llaves correspondientes.
## Por motivos de seguridad se dejarán los repositorios listos para usar en
## el sistema pero comentados, es decir, los que considero que depende del
## usuario activarlos y usarlo bajo su responsabilidad están comentados.

###########################
##       FUNCIONES       ##
###########################
##
## Añade llaves oficiales para cada repositorio
##
testing_agregar_llaves() {
    echo -e "$VE Agregando llaves solo para repositorios$RO testing$CL"
}

##
## Crea Backups de repositorios y añade nuevas listas
##
testing_sources_repositorios() {
    echo -e "$VE Añadido$RO sources.list$VE y$RO sources.list.d/$VE Agregados$CL"

    crearBackup '/etc/apt/sources.list' '/etc/apt/sources.list.d/'

    if [[ ! -d '/etc/apt/sources.list.d' ]]; then
        sudo mkdir -p '/etc/apt/sources.list.d'
    fi
    sudo cp $WORKSCRIPT/Repositorios/debian/testing/sources.list.d/* /etc/apt/sources.list.d/

    if [[ ! -d '/etc/apt/sources.list' ]]; then
        sudo rm -f '/etc/apt/sources.list'
    fi
    sudo cp "$WORKSCRIPT/Repositorios/debian/testing/sources.list" "/etc/apt/sources.list"
}

##
## Agrega los repositorios desde su directorio "testing"
##
testing_download_repositorios() {
    echo -e "$VE Descargando repositorios desde scripts oficiales$CL"
}

##
## Añade todos los repositorios y llaves
##
testing_agregar_repositorios() {
    echo -e "$VE Instalando repositorios$RO Debian Testing$CL"
    testing_sources_repositorios
    testing_download_repositorios
    echo -e "$VE Actualizando antes de obtener las llaves, es normal que se muestren errores$AM (Serán solucionados en el próximo paso)$CL"
    actualizarRepositorios
    testing_agregar_llaves
    echo -e "$VE Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    actualizarRepositorios
}
