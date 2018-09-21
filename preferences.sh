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
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

############################
##       FUNCIONES        ##
############################
getDistrosAvailable() {
    echo -e "$RO debian$VE → stable-testing-unstable$CL"
    echo -e "$RO gentoo$VE → stable-testing-unstable$CL"
    echo -e "$RO raspbian$VE → stable-testing-unstable$CL"
    echo -e "$RO fedora$VE → stable$CL"
}

setDistro() {
    while [[ "$MY_DISTRO" != 'debian' ]] &&
          [[ "$MY_DISTRO" != 'gentoo' ]] &&
          [[ "$MY_DISTRO" != 'raspbian' ]] &&
          [[ "$MY_DISTRO" != 'fedora' ]]
    do
        clear
        getDistrosAvailable
        ## Pido elegir distribución
        echo "$MY_DISTRO"
        read -p "Introduce tu distribución → " MY_DISTRO
    done

    setVariableGlobal 'DISTRO' "$MY_DISTRO"
}

setBranch() {
    while [[ "$MY_BRANCH" != 'stable' ]] &&
          [[ "$MY_BRANCH" != 'testing' ]] &&
          [[ "$MY_BRANCH" != 'unstable' ]]
    do
        clear
        getDistrosAvailable
        ## Pido elegir distribución
        echo "$MY_BRANCH"
        read -p "Introduce la rama → " MY_BRANCH
    done

    setVariableGlobal 'BRANCH' "$MY_BRANCH"
}

##
## Configura las Opciones del entorno para usar el script
##
configurePreferences() {
    echo -e "$VE Puedes setear tu mismo las variables en /etc/environment$CL"
    setDistro
    setBranch

    ## Recarga variables del entorno
    source '/etc/environment'
}
