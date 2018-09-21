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
## @style      https://gitlab.com/fryntiz/bash-style-guide
##

############################
##     INSTRUCCIONES      ##
############################
## Añade las variables globales al sistema operativo para poder ser
## consultadas en cualquier momento y declaradas desde el momento de arranque.

############################
##       FUNCIONES        ##
############################
##
## Establece variables globales en /etc/environment
##
variablesGlobales() {
    echo -e "$VE Instalando$RO Variables Globales$VE al sistema$CL"
    if [[ "$1" = 'pro' ]];then
        setVariableGlobal 'ENV' 'prod'
        setVariableGlobal 'DEBIAN_VERSION' 'stable'
    else
        setVariableGlobal 'ENV' 'dev'
    fi

    setVariableGlobal 'LC_ALL' 'es_ES.UTF-8'
    setVariableGlobal 'LC_CTYPE' 'es_ES.UTF-8'
    setVariableGlobal 'LC_MESSAGES' 'es_ES.UTF-8'
}

# Importa todas las variables al inicio del sistema Operativo
instalar_variables() {
    variablesGlobales $1
}
