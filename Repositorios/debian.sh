#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
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
## Prepara y configura los repositorios para cualquiera de las distintas
## ramas que hay en Debian.

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Repositorios/debian/stable.sh"
source "$WORKSCRIPT/Repositorios/debian/testing.sh"
source "$WORKSCRIPT/Repositorios/debian/unstable.sh"
source "$WORKSCRIPT/Repositorios/debian/common_vps.sh"
source "$WORKSCRIPT/Repositorios/debian/common.sh"

############################
##       FUNCIONES        ##
############################
agregarRepositoriosDebian() {
    echo -e "$VE Configurando Repositorios para$RO Debian$CL"

    ##
    ## Instala dependencias para actualizar repositorios e instalar
    ##
    instalar_dependencias() {
        echo -e "$VE Actualizando repositorios por primera vez$CL"
        actualizarRepositorios
        instalarSoftware 'apt-transport-https'
        instalarSoftware 'dirmngr'
        instalarSoftware 'wget'
        instalarSoftware 'curl'
        instalarSoftware 'gnupg'
        instalarSoftware 'rng-tools'

        ## Habilito software para arquitectura de 32 bits
        sudo dpkg --add-architecture i386

        actualizarRepositorios
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
            clear_screen

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
                    clear_screen
                    echo -e "$RO Se sale del menú$CL"
                    echo ''
                    break;;

                *)  ## Acción ante entrada no válida
                    echo ""
                    echo -e "             $RO ATENCIÓN: Elección no válida$CL";;
            esac
        done
    }

    ## Is a VPS
    if [[ "$BRANCH" = 'stable' ] && ["$MY_ENV" = 'prod' ] ]; then
        vps_add_repositories
        common_vps_add_repository
    else; then  ## Not a VPS
        if [[ "$BRANCH" = 'stable' ]]; then
            stable_agregar_repositorios
        elif [[ "$BRANCH" = 'testing' ]]; then
            testing_agregar_repositorios
        elif [[ "$BRANCH" = 'unstable' ]]; then
            unstable_agregar_repositorios
        else
            elegirRama
        fi

        common_vps_add_repositories
        common_add_repositories
    fi

    ## Asigna lectura a todos para buscar paquetes sin sudo
    sudo chmod 744 /etc/apt/sources.list
    sudo chmod 744 -R /etc/apt/sources.list.d
    sudo chmod 755 /etc/apt/sources.list.d
}
