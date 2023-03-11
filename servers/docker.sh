#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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

docker_download() {
    echo -e "$VE Descargando$RO Docker$CL"
}

docker_before_install() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Docker$CL"

    sudo groupadd docker
    sudo usermod -a -G docker "$USER"

    if [[ ! -d '/var/docker' ]]; then
        sudo mkdir '/var/docker'
        sudo chown :docker '/var/docker'
        sudo chmod ugo+rx -R '/var/docker'
        sudo chmod ug+w -R '/var/docker'
        sudo chmod g+s -R '/var/docker'
    fi

    if [[ ! -d '/var/docker/apps' ]]; then
        sudo mkdir '/var/docker/apps'
        sudo chown :docker '/var/docker/apps'
        sudo chmod ugo+rx -R '/var/docker/apps'
        sudo chmod ug+w -R '/var/docker/apps'
        sudo chmod g+s -R '/var/docker/apps'
    fi

    if [[ ! -d '/var/docker/builds' ]]; then
        sudo mkdir '/var/docker/builds'
        sudo chown :docker '/var/docker/builds'
        sudo chmod ugo+rx -R '/var/docker/builds'
        sudo chmod ug+w -R '/var/docker/builds'
        sudo chmod g+s -R '/var/docker/builds'
    fi

    if [[ ! -d '/var/docker/images' ]]; then
        sudo mkdir '/var/docker/images'
        sudo chown :docker '/var/docker/images'
        sudo chmod ugo+rx -R '/var/docker/images'
        sudo chmod ug+w -R '/var/docker/images'
        sudo chmod g+s -R '/var/docker/images'
    fi
}

docker_install() {
    echo -e "$VE Instalando$RO Docker$CL"
    instalarSoftwareLista "${SOFTLIST}/servers/docker.lst"
}

docker_after_install() {
    echo -e "$VE Generando Post-Configuraciones de$RO Docker$CL"
}

docker_installer() {
    docker_download
    docker_before_install
    docker_install
    docker_after_install
}
