#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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
## Instala configuraciones

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
        sudo mv '/etc/hosts' '/etc/hosts.BACKUP'
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
## Instalar Todas las configuraciones
##
instalar_configuraciones() {
    cd "$WORKSCRIPT"

    configurar_hosts

    sudo update-command-not-found >> /dev/null 2>> /dev/null
}
