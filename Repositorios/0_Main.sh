#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Repositorios/comunes.sh"
source "$WORKSCRIPT/Repositorios/stable.sh"
source "$WORKSCRIPT/Repositorios/testing.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú para configurar e integrar repositorios.
## @param $1 -a Si recibe este parámetro lo hará de forma automática
##
menuRepositorios() {

    ## Si la función recibe "-a" indica que detecte de forma automática
    if [[ "$1" = '-a' ]]; then
        local testing='buster/sid buster buster/testing testing'
        local stable='stretch stable'
        local version=''    ## Indica los repositorios a configurar
        local testing=False

        ## Almaceno el primer caracter de la versión ("9" por ejemplo en stable)
        #local v_stable=$(cat /etc/debian_version | cut -d. -f1)

        if [[ -f '/etc/debian_version' ]]; then
            version=$(cat '/etc/debian_version')
        else
            version='stable'
        fi

        for v in $testing; do
            if [[ $v = $version ]]; then
                testing=True
                break
            fi
        done

        if [[ $testing = True ]]; then
            testing_agregar_repositorios
        else
            stable_agregar_repositorios
        fi
    else
        while true :; do
            clear
            local descripcion='Menú para configurar e integrar repositorios
                1) Stable
                2) Testing

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  stable_agregar_repositorios;;
                2)  testing_agregar_repositorios;;

                0)  ## SALIR
                    clear
                    echo -e "$RO Se sale del menú$CL"
                    echo ''
                    break;;

                *)  ## Acción ante entrada no válida
                    echo ""
                    echo -e "             $RO ATENCIÓN: Elección no válida$CL";;
            esac
        done
    fi
}
