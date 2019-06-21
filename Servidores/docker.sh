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

docker_descargar() {
    echo -e "$VE Descargando$RO Docker$CL"
}

docker_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Docker$CL"

    sudo groupadd docker
    sudo usermod -a -G docker "$USER"
}

docker_instalar() {
    echo -e "$VE Instalando$RO Docker$CL"
    instalarSoftwareLista "${SOFTLIST}/Servidores/docker.lst"
}

docker_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO Docker$CL"
}

docker_instalador() {
    docker_descargar
    docker_preconfiguracion
    docker_instalar
    docker_postconfiguracion
}
