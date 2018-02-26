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

############################
##        FUNCIONES       ##
############################

python_descargar() {
    echo "$VE Descargando$RO python$CL"
}

python_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO python"
}

python_instalar() {
    echo -e "$VE Instalando$RO Python y Django$CL"
    ## Instalar python y gestor de paquetes
    instalarSoftware python python3 python-pip python3-pip
}

python_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de python"

    configurar_python2() {
        echo -e "$VE Preparando configuracion de$RO Python2$CL"
    }

    configurar_python3() {
        echo -e "$VE Preparando configuracion de$RO Python3$CL"
    }

    personalizar_python2() {
        echo -e "$VE Personalizando$RO Python y Django$CL"
        ## Closure linter
        pip install https://github.com/google/closure-linter/zipball/master
    }

    personalizar_python3() {
        echo -e "$VE Personalizando$RO Python3$CL"
        ## Closure linter
        pip3 install https://github.com/google/closure-linter/zipball/master
    }

    configurar_python2
    configurar_python3
    personalizar_python2
    personalizar_python3
}


python_instalador() {
    python_descargar
    python_preconfiguracion
    python_instalar
    python_postconfiguracion
}
