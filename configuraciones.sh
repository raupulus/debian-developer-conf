#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https::/fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Instala configuraciones del entorno.

###########################
##       FUNCIONES       ##
###########################

##
## Crea un archivo hosts muy completo que bloquea bastantes
## sitios malignos en la web evitando riesgos y mejorando navegabilidad
##
configurar_hosts() {
    echo -e "$VE Configurar archivo$RO /etc/hosts$CL"

    ## Crea copia del original para mantenerlo siempre
    if [[ ! -f '/etc/hosts.BACKUP' ]]; then
        if [[ -f '/etc/hosts' ]]; then
            sudo mv '/etc/hosts' '/etc/hosts.BACKUP'
        fi
    fi

    if [[ -f '/etc/hosts.BACKUP' ]]; then
        cat '/etc/hosts.BACKUP' > "$WORKSCRIPT/tmp/hosts"
        cat "$WORKSCRIPT/conf/etc/hosts" >> "$WORKSCRIPT/tmp/hosts"
        sudo cp "$WORKSCRIPT/tmp/hosts" '/etc/hosts'
    else
        echo -e "$VE Existe algún problema con el archivo$RO /etc/hosts$CL"
        echo -e "$VE Te recomiendo revisar esto manualmente$CL"
    fi
}

##
## Genera la estructura de directorios para el usuario actual en su home.
##
generate_home_structure() {
    echo -e "$VE Generando$RO estructura de directorios$CL"

    dir_exist_or_create "$HOME/.local"
    dir_exist_or_create "$HOME/.local/bin"
    dir_exist_or_create "$HOME/.local/lib"
    dir_exist_or_create "$HOME/.local/opt"
    dir_exist_or_create "$HOME/.local/share"

    dir_exist_or_create "$HOME/.config"

    dir_exist_or_create "$HOME/Imágenes"
    dir_exist_or_create "$HOME/Imágenes/Screenshots"
}

##
## Instalar Todas las configuraciones
##
instalar_configuraciones() {
    cd "$WORKSCRIPT" || exit 1

    configurar_hosts

    generate_home_structure

    sudo update-command-not-found >> /dev/null 2>> /dev/null
}
