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
## Este script agrega los repositorios estables y algunos más de forma segura
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
stable_agregar_llaves() {
    echo -e "$VE Instalando llaves de repositorios$CL"

    sudo apt install -y debian-keyring 2>> /dev/null
    sudo apt install -y pkg-mozilla-archive-keyring 2>> /dev/null
    sudo apt install -y deb-multimedia-keyring 2>> /dev/null

    ## Multisystem
    echo -e "$VE Agregando clave para$RO Multisystem$CL"
    sudo wget -q -O - http://liveusb.info/multisystem/depot/multisystem.asc | sudo apt-key add -

    ## Webmin
    echo -e "$VE Agregando clave para$RO Webmin$CL"
    wget http://www.webmin.com/jcameron-key.asc && sudo apt-key add jcameron-key.asc
    sudo rm jcameron-key.asc

    ## Virtualbox Oficial
    echo -e "$VE Agregando clave para$RO Virtualbox$CL"
    wget https://www.virtualbox.org/download/oracle_vbox_2016.asc
    sudo apt-key add oracle_vbox_2016.asc
    sudo rm oracle_vbox_2016.asc

    ## Docker
    echo -e "$VE Agregando clave para$RO Docker$CL"
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys F76221572C52609D

    ## Heroku
    echo -e "$VE Agregando clave para$RO Heroku$CL"
    curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -

    ## Kali Linux
    echo -e "$VE Agregando clave para$RO Kali Linux$CL"
    sudo apt-key adv --keyserver pgp.mit.edu --recv-keys ED444FF07D8D0BF6

    ## Mi propio repositorio en launchpad
    echo -e "$VE Agregando clave para$RO Fryntiz Repositorio$CL"
    gpg --keyserver keyserver.ubuntu.com --recv-key B5C6D9592512B8CD && gpg -a --export $PUBKRY | sudo apt-key add -

    ## Repositorio de PostgreSQL Oficial
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

    ## Repositorio de NodeJS Oficial
    echo -e "$VE Agregando clave para$RO NodeJS Repositorio Oficial$CL"
    curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -

    ## Repositorio para Tor oficial y estable
    echo -e "$VE Agregando clave para$RO Tor Repositorio$CL"
    gpg --keyserver keys.gnupg.net --recv A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 && gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -
    sudo apt update
    sudo apt install deb.torproject.org-keyring
}

##
## Crea Backups de repositorios y añade nuevas listas
##
stable_sources_repositorios() {
    echo -e "$VE Añadido$RO sources.list$VE y$RO sources.list.d/$VE Agregados$CL"

    crearBackup '/etc/apt/sources.list' '/etc/apt/sources.list.d/'

    if [[ ! -d '/etc/apt/sources.list.d' ]]; then
        sudo mkdir -p '/etc/apt/sources.list.d'
    fi
    sudo cp $WORKSCRIPT/Repositorios/stable/sources.list.d/* /etc/apt/sources.list.d/

    if [[ ! -d '/etc/apt/sources.list' ]]; then
        sudo rm -f '/etc/apt/sources.list'
    fi
    sudo cp "$WORKSCRIPT/Repositorios/stable/sources.list" "/etc/apt/sources
    .list"
}

##
## Instala dependencias para actualizar repositorios e instalar
##
stable_preparar_repositorios() {
    echo -e "$VE Actualizando repositorios por primera vez$CL"
    sudo apt update >> /dev/null 2>> /dev/null
    instalarSoftware apt-transport-https && echo -e "$VE Instalado el paquete$RO apt-transport-https$CL" || echo -e "$VE Error al instalar$RO apt-transport-https$CL"

    instalarSoftware dirmngr && echo -e "$VE Instalado el paquete$RO dirmngr$CL" || echo -e "$VE Error al instalar$RO dirmngr$CL"
    echo -e "$VE Agregando Repositorios$CL"

    instalarSoftware 'curl'
}

##
## Añade Repositorios extras a Debian
##
stable_agregar_repositorios() {
    stable_preparar_repositorios
    stable_sources_repositorios

    echo -e "$VE Actualizando listas de$RO repositorios$VE por segunda vez$CL"
    sudo apt update

    stable_agregar_llaves

    echo -e "$VE Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    sudo apt update
}
