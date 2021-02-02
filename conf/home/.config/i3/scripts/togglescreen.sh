#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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
    local RELOAD=$1
    local CURRENT_SCRIPT_NAME=''
    local primera=''
    local siguiente=''
    local nombreScript=''  ## Nombre del script a ejecutar.

    for config in ${DIR_LAYOUTS}/*; do
        ## Almaceno el primer archivo.
        if [[ $primera = '' ]]; then
            primera=$config

            ## Almaceno el nombre del primer script para poder recargar.
            CURRENT_SCRIPT_NAME=$config
        fi

        ## Cuando se encuentra el actual se anota para ejecutar siguiente
        if [[ $siguiente = 'true' ]]; then
            nombreScript=$config
            break
        elif [[ $config = $LAYOUT_ACTUAL ]]; then
            ## Almaceno el nombre del script actual en uso para poder recargar.
            CURRENT_SCRIPT_NAME=$config

            ## Almaceno que se ha encontrado el actual, para ejecutar siguiente.
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

    ## En caso de haber recibido recargar la pantalla, cargará la actual.
    if [[ "$RELOAD" = 'true' ]]; then
        ## Ejecuto el script para recargar la pantalla actual.
        $($CURRENT_SCRIPT_NAME)
        ## Notifico el script actual.
        notify-send "Recargando pantalla actual"
    else
        ## Ejecuto el script para cambiar a la pantalla siguiente.
        $($nombreScript)

        ## Notifico el script actual.
        notify-send "Se está utilizando el siguiente script: $nombreScript"
    fi
}

## Compruebo si recibe la variable para recargar configuración actual.
if [[ "$1" = 'true' ]] || [[ "$1" = 'reload' ]]; then
    conmutarSalidasPantalla 'true'
else
    conmutarSalidasPantalla 'false'
fi

exit 0
