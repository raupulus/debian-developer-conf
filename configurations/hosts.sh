#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

###########################
##       FUNCTIONS       ##
###########################

##
## Crea un archivo hosts muy completo que bloquea bastantes
## sitios malignos en la web evitando riesgos y mejorando navegabilidad
##
configurations_hosts() {
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
