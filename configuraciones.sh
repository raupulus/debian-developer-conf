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

    ## La primera vez se traslada a un archivo que se usará para local.
    if [[ ! -f '/etc/hosts.local' ]] && [[ -f '/etc/hosts' ]]; then
        sudo cp '/etc/hosts' '/etc/hosts.local'
    fi

    ## Crea copia del último archivo antes de actualizar
    if [[ -f '/etc/hosts' ]]; then
        sudo mv '/etc/hosts' '/etc/hosts.BACKUP'
    fi

    if [[ ! -f '/etc/hosts' ]]; then
        sudo touch '/etc/hosts'
    fi

    if [[ -f '/etc/hosts.local' ]]; then
            sudo cat '/etc/hosts.local' | sudo tee "/etc/hosts"
    else
        echo -e "$VE Existe algún problema con el archivo$RO /etc/hosts.local$CL"
        echo -e "$VE Te recomiendo revisar esto manualmente$CL"
    fi

    echo -e "$VE Descargando actualización de$RO Hosts Bloqueados$CL"
    sudo wget https://hosts.ubuntu101.co.za/hosts -O '/tmp/hosts' && sudo cat '/tmp/hosts' | sudo tee -a '/etc/hosts'

    echo '' && echo ''

    echo -e "$VE Descargando actualización de$RO Hosts Denegados$CL"
    sudo wget https://hosts.ubuntu101.co.za/superhosts.deny -O '/etc/hosts.deny'

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
