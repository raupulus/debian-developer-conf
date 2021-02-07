#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################

gocd_download() {
    echo -e "$VE Descargando$RO GoCD$CL"
}

gocd_before_install() {
    echo -e "$VE Generando Pre-Configuraciones de$RO GoCD$CL"

    sudo groupadd gocd
    sudo usermod -a -G gocd "$USER"

    if [[ ! -d '/mnt/artifact-storage' ]]; then
        sudo mkdir '/mnt/artifact-storage'
        sudo chown go:go '/mnt/artifact-storage'
        sudo chmod ugo+rx -R '/mnt/artifact-storage'
        sudo chmod ug+w -R '/mnt/artifact-storage'
        sudo chmod g+s -R '/mnt/artifact-storage'
    fi

    ## TODO → Comprobar si está postgresql instalado
}

gocd_install() {
    echo -e "$VE Instalando$RO GoCD$CL"
    instalarSoftwareLista "${SOFTLIST}/servers/gocd.lst"
}

gocd_after_install() {
    echo -e "$VE Generando Post-Configuraciones de$RO GoCD$CL"
}

gocd_installer() {
    gocd_download
    gocd_before_install
    gocd_install
    gocd_after_install
}
