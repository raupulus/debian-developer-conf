#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

mongodb_descargar() {
    echo -e "$VE Descargando$RO mongodb$CL"
}

mongodb_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO mongodb$CL"

    if [[ $DISTRO != 'macos' ]]; then
        sudo groupadd mongodb
        sudo usermod -a -G mongodb "$USER"
    fi
}

mongodb_instalar() {
    echo -e "$VE Instalando$RO mongodb$CL"
    instalarSoftwareLista "${SOFTLIST}/servers/mongodb.lst"
    mongod --config /opt/homebrew/etc/mongod.conf --fork
}

mongodb_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO mongodb$CL"

    if [[ $DISTRO = 'macos' ]]; then
        brew services start mongodb-community
    else
        sudo systemctl start mongod || sudo systemctl daemon-reload && sudo systemctl start mongod
        sudo systemctl status mongod
        sudo systemctl enable mongod
    fi
}

mongodb_instalador() {
    mongodb_descargar
    mongodb_preconfiguracion
    mongodb_instalar
    mongodb_postconfiguracion
}
