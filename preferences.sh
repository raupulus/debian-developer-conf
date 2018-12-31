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
    while [[ "$input" != 'debian' ]] &&
          [[ "$input" != 'gentoo' ]] &&
          [[ "$input" != 'raspbian' ]] &&
          [[ "$input" != 'fedora' ]]
    do
        clear
        getDistrosAvailable
        ## Pido elegir distribución
        echo "$MY_DISTRO"
        read -p "Introduce tu distribución → " input
    done

    MY_DISTRO="$input"

    setVariableGlobal 'DISTRO' "$MY_DISTRO"
}

setBranch() {
    while [[ "$input" != 'stable' ]] &&
          [[ "$input" != 'testing' ]] &&
          [[ "$input" != 'unstable' ]]
    do
        clear
        getDistrosAvailable
        ## Pido elegir distribución
        echo "$MY_BRANCH"
        read -p "Introduce la rama → " input
    done

    MY_BRANCH="$input"

    setVariableGlobal 'BRANCH' "$MY_BRANCH"
}

##
## Permite establecer si nos encontramos en un entorno para desarrollo o para
## producción mediante una variable global $ENV
##
setEnv() {
    while true :; do
        clear

        local descripcion='Selecciona el entorno:
            1) Producción
            2) Desarrollo
        '
        opciones "$descripcion"

        echo -e "$RO"
        read -p '    Acción → ' entrada
        echo -e "$CL"

        case ${entrada} in

            1) setVariableGlobal 'ENV' "prod"
               break;;
            2) setVariableGlobal 'ENV' "dev"
               break;;

            *)  ## Acción ante entrada no válida
              clear
              echo ""
              echo -e "                   $RO ATENCIÓN: Elección no válida$CL";;
        esac
    done
}

##
## Configura variables para el idioma
##
variables_lenguaje() {
    if [[ "$LC_ALL" = '' ]]; then
        setVariableGlobal 'LC_ALL' 'es_ES.UTF-8'
    fi

    if [[ "$LC_CTYPE" = '' ]]; then
        setVariableGlobal 'LC_CTYPE' 'es_ES.UTF-8'
    fi

    if [[ "$LC_MESSAGES" = '' ]]; then
        setVariableGlobal 'LC_MESSAGES' 'es_ES.UTF-8'
    fi
}

##
## Configura las Opciones del entorno para usar el script
##
configurePreferences() {
    ## Recarga variables del entorno
    source '/etc/environment'

    ##
    ## Toma las variables desde el archivo .env en la raíz del script
    ## Esto sobreescribe otros valores existentes que hubiesen en environment
    ##
    if [[ -f "$WORKSCRIPT/.env" ]]; then
        source "$WORKSCRIPT/.env"
    fi

    echo -e "$VE Puedes setear tu mismo las variables en /etc/environment$CL"
    echo -e "$VE También puedes usar .env en este directorio del script$CL"

    if [[ "$MY_DISTRO" = '' ]]; then
        setDistro
    fi

    if [[ "$MY_BRANCH" = '' ]]; then
        setBranch
    fi

    if [[ "$ENV" = '' ]]; then
        setEnv
    fi

}
