#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
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
## Prepara y configura los repositorios para Raspbian Stable.

############################
##     IMPORTACIONES      ##
############################

############################
##       FUNCIONES        ##
############################
agregarRepositoriosRaspbian() {
    echo '$VE Configurando Repositorios para$RO Raspbian$CL'

    ##
    ## Instala dependencias para actualizar repositorios e instalar
    ##
    instalar_dependencias() {
        echo -e "$VE Actualizando repositorios por primera vez$CL"
        actualizarRepositorios
        instalarSoftware 'apt-transport-https'
        instalarSoftware 'dirmngr'
        instalarSoftware 'curl'
    }

    ##
    ## Instala paquetes para gestionar llaves de repositorios
    ##
    prepararLlaves() {
        echo -e "$VE Instalando llaves de repositorios$CL"
        instalarSoftware debian-keyring
        instalarSoftware pkg-mozilla-archive-keyring
    }

    ##
    ## Crea Backups de repositorios y añade nuevas listas
    ##
    raspbian_sources_repositorios() {
        echo -e "$VE Añadido$RO sources.list$VE y$RO sources.list.d/$VE Agregados$CL"

        crearBackup '/etc/apt/sources.list' '/etc/apt/sources.list.d/'

        if [[ ! -d '/etc/apt/sources.list.d' ]]; then
            sudo mkdir -p '/etc/apt/sources.list.d'
        fi
        sudo cp $WORKSCRIPT/Repositorios/raspbian/sources.list.d/* /etc/apt/sources.list.d/

        if [[ ! -d '/etc/apt/sources.list' ]]; then
            sudo rm -f '/etc/apt/sources.list'
        fi
        sudo cp "$WORKSCRIPT/Repositorios/raspbian/sources.list" "/etc/apt/sources.list"
    }

    instalar_dependencias
    prepararLlaves
    raspbian_sources_repositorios

    ## Asigna lectura a todos para buscar paquetes sin sudo
    sudo chmod 744 /etc/apt/sources.list
    sudo chmod 744 -R /etc/apt/sources.list.d
    sudo chmod 755 /etc/apt/sources.list.d
}
