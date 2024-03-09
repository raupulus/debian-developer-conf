#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-

mainZone() {
    instalarSoftware 'locales'

    local localegen='/etc/locale.gen'

    ## Descomento lenguaje en_US
    sudo sed -r -i "s/^#?\s*en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" "$localegen"

    ## Descomentar en /etc/locale.gen es_ES.UTF-8 UTF-8
    sudo sed -r -i "s/^#?\s*es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/" "$localegen"

    ## Exporto variables de idiomas
    export LC_ALL="es_ES.UTF-8"
    export LC_CTYPE="es_ES.UTF-8"
    export LC_MESSAGES="es_ES.UTF-8"

    ## Reconfigurando locales y zona
    sudo dpkg-reconfigure locales
    sudo dpkg-reconfigure tzdata
    sudo locale-gen
}
