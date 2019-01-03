#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
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
source "$WORKSCRIPT/Repositorios/stable.sh"
source "$WORKSCRIPT/Repositorios/testing.sh"
source "$WORKSCRIPT/Repositorios/unstable.sh"
source "$WORKSCRIPT/Repositorios/comunes.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú para configurar e integrar repositorios.
## @param $1 -a Si recibe este parámetro lo hará de forma automática
##
menuRepositorios() {
    ##
    ## Instala dependencias para actualizar repositorios e instalar
    ##
    instalar_dependencias() {
        echo -e "$VE Actualizando repositorios por primera vez$CL"
        actualizarRepositorios
        instalarSoftware 'apt-transport-https'
        instalarSoftware 'dirmngr'
        instalarSoftware 'curl'
    }

    ##
    ## Instala paquetes para gestionar llaves de repositorios
    ##
    prepararLlaves() {
        echo -e "$VE Instalando llaves de repositorios$CL"
        instalarSoftware debian-keyring
        instalarSoftware pkg-mozilla-archive-keyring
    }

    instalar_dependencias
    prepararLlaves

    elegirRama() {
        while true; do
            clear

            local descripcion='Menú para configurar e integrar repositorios
                1) Stable
                2) Testing
                3) Unstable

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in
                1)  stable_agregar_repositorios
                    break;;
                2)  testing_agregar_repositorios
                    break;;
                3)  unstable_agregar_repositorios
                    break;;

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
    }

    ## Si la función recibe "-a" indica que detecte de forma automática
    local unstable=('sid' 'unstable')
    local testing=('buster' 'buster/testing' 'testing')
    local version='stable'    ## Indica los repositorios a configurar

    ## Almaceno el primer caracter de la versión ("9" por ejemplo en stable)
    local v_stable=$(cat /etc/debian_version | cut -d. -f1)

    if [[ -f '/etc/debian_version' ]]; then
        version=$(cat '/etc/debian_version')
    else
        version='stable'
    fi

    for v in ${testing[@]}; do
        if [[ $v = $version ]]; then
            version='testing'
            break
        elif [[ $v = $version ]]; then
            version='unstable'
            break
        fi
    done

    if [[ "$BRANCH" = 'stable' ]] ||
       [[ $version = 'stable' ]] ||
       [[ $(echo $version | cut -d. -f1) = $v_stable ]]; then
        stable_agregar_repositorios
    elif [[ "$BRANCH" = 'testing' ]] ||
         [[ $version = 'testing' ]]; then
        testing_agregar_repositorios
    elif [[ "$BRANCH" = 'unstable' ]] ||
         [[ $version = 'unstable' ]]; then
        unstable_agregar_repositorios
    else
        elegirRama
    fi

    comunes_agregar_repositorios

    ## Asigna lectura a todos para buscar paquetes sin sudo
    sudo chmod 744 /etc/apt/sources.list
    sudo chmod 744 -R /etc/apt/sources.list.d
    sudo chmod 755 /etc/apt/sources.list.d
}
