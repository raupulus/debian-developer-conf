#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-

mainZone() {
    instalarSoftware 'locales'

    local localegen='/etc/locale.gen'

    ## Descomentar en /etc/locale.gen es_ES.UTF-8 UTF-8
    sudo sed -r -i "s/^#?\s*es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/" "$localegen"

    ## Comprobar si existen las variables en /etc/environment para agregarlas
    #echo "LC_ALL=es_ES.UTF-8" | sudo tee -a /etc/environment
    #echo "LC_CTYPE=es_ES.UTF-8" | sudo tee -a /etc/environment
    #echo "LC_MESSAGES=es_ES.UTF-8" | sudo tee -a /etc/environment

    ## Exporto variables de idiomas
    export LC_ALL="es_ES.UTF-8"
    export LC_CTYPE="es_ES.UTF-8"
    export LC_MESSAGES="es_ES.UTF-8"

    ## Reconfigurando locales y zona
    sudo dpkg-reconfigure locales
    sudo dpkg-reconfigure tzdata
    sudo locale-gen
}
