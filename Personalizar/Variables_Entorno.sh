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
    if [[ $ENV = '' ]]; then
        echo -e "$VE Agregando variable como entorno de producción$CL"
        echo 'ENV=dev' | sudo tee -a /etc/environment
        export ENV='dev'
    fi
}

# Importa todas las variables al inicio del sistema Operativo
instalar_variables() {
    variablesGlobales
}
