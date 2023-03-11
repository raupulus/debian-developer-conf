#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
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
## Prepara y configura los repositorios para Raspbian Stable.

############################
##     IMPORTACIONES      ##
############################

############################
##       FUNCIONES        ##
############################
agregarRepositoriosRaspbian() {
    echo -e "$VE Configurando Repositorios para$RO Raspbian$CL"

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

        ## Agregando llave para Gitlab Runner.
        echo -e "$VE Agregando llave para$RO Gitlab Runner$CL"
        curl -L "https://packages.gitlab.com/runner/gitlab-runner/gpgkey" 2> /dev/null | sudo apt-key add - &>/dev/null

        ## Sury (Paquetes PHP)
        echo -e "$VE Agregando llave para$RO PHP$VE de sury,org$CL"
        sudo wget -O '/etc/apt/trusted.gpg.d/php.gpg' 'https://packages.sury.org/php/apt.gpg'
        sudo chmod 744 '/etc/apt/trusted.gpg.d/php.gpg'
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

        if [[ -f '/etc/apt/sources.list' ]]; then
            sudo rm -f '/etc/apt/sources.list'
        fi

        sudo cp "$WORKSCRIPT/Repositorios/raspbian/sources.list" "/etc/apt/sources.list"

        ## Sury (Paquetes PHP)
        echo -e "$VE Agregando repositorio$RO Sury$AM Repositorio Oficial$CL"
        #echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
        echo "deb https://packages.sury.org/php/ buster main" | sudo tee /etc/apt/sources.list.d/php.list
    }

    ##
    ## Repositorio de NodeJS Oficial
    ##
    raspbian_source_nodejs() {
        echo -e "$VE Agregando repositorio$RO NodeJS$AM Repositorio Oficial$CL"
        curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
    }

    ##
    ## Repositorio oficial de Flightaware
    ##
    raspbian_source_piaware() {
        wget https://flightaware.com/adsb/piaware/files/packages/pool/piaware/p/piaware-support/piaware-repository_4.0_all.deb -O /tmp/piaware-repository.deb

        sudo dpkg -i /tmp/piaware-repository.deb
    }

    instalar_dependencias
    prepararLlaves
    raspbian_sources_repositorios
    raspbian_source_nodejs
    raspbian_source_piaware

    ## Asigna lectura a todos para buscar paquetes sin sudo
    sudo chmod 744 /etc/apt/sources.list
    sudo chmod 744 -R /etc/apt/sources.list.d
    sudo chmod 755 /etc/apt/sources.list.d
}
