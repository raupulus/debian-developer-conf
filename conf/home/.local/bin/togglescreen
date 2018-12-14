#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################
## Conmuta entre las configuraciones de pantalla existente.

## Los scripts de ARANDR se guardan por defecto en ~/.screenlayout
DIR_LAYOUTS=$HOME/.screenlayout

if [[ ! -d /tmp/${USER} ]]; then
    mkdir /tmp/${USER}
    chmod 700 /tmp/${USER}
fi

if [[ ! -f /tmp/${USER}/monitoreslayout ]]; then
    touch /tmp/${USER}/monitoreslayout
    chmod 600 /tmp/${USER}/monitoreslayout
fi

LAYOUT_ACTUAL=$(cat /tmp/${USER}/monitoreslayout)

conmutarSalidasPantalla() {
    local primera=''
    local siguiente=''
    local nombreScript=''  ## Nombre del script a ejecutar.

    for config in ${DIR_LAYOUTS}/*; do
        ## Almaceno el primer archivo.
        if [[ $primera = '' ]]; then
            primera=$config
        fi

        ## Cuando se encuentra el actual se anota para ejecutar siguiente
        if [[ $siguiente = 'true' ]]; then
            nombreScript=$config
            break
        elif [[ $config = $LAYOUT_ACTUAL ]]; then
            siguiente='true'
        fi

    done

    ## Si es la última configuración se toma la primera
    if [[ $nombreScript = '' ]]; then
        nombreScript=$primera
    fi

    ## Almaceno la configuración de monitores actual.
    echo $nombreScript > /tmp/${USER}/monitoreslayout
    chmod 600 /tmp/${USER}/monitoreslayout

    ## Ejecuto el script para cambiar la pantalla.
    $($nombreScript)

    ## Notifico el script actual.
    notify-send "Se está utilizando el siguiente script: $nombreScript"
}

conmutarSalidasPantalla

exit 0
