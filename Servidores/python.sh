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
## Instala python 2, python 3, Django y gestor de paquete pip para ambas
## versiones de php.
## Además instala paquetes básicos recurridos, correctores de sintaxis y reglas
## de estilos para PEP8 principalmente.

############################
##        FUNCIONES       ##
############################

python_descargar() {
    echo -e "$VE Descargando$RO python$CL"

    ## Descargando pyenv para gestionar versión de python en un proyecto
    descargarGIT 'Pyenv' 'https://github.com/pyenv/pyenv.git' "$HOME/.pyenv"
}

python_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO python"
}

python_instalar() {
    echo -e "$VE Instalando$RO Python y Django$CL"
    ## Instalar python y gestor de paquetes
    instalarSoftware python python3 python-pip python3-pip

    ## Instalando dependencias
    echo -e "$VE Instalando dependencias$CL"

    local dependencias='flake8 pyflakes pyflakes3 pydocstyle pylama prospector virtualenv'
    instalarSoftware "$dependencias"
}

python_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de python"

    configurar_python2() {
        echo -e "$VE Preparando configuracion de$RO Python2$CL"
        echo -e "$VE Instalando dependencias para Python 2$CL"

        local dependencias='python-autopep8 python-bottle python-cryptography python-dev python-enum34 python-flake python-frozendict python-future python-idna python-ipaddress python-ipython python-jedi python-mccabe python-mysqldb python-openssl python-pep8 python-pip python-powerline python-powerline-taskwarrior python-pyasn1 python-pycodestyle python-pyflakes python-pygments python-pylama python-setuptools python-urllib3 python-virtualenv python-waitress'

        instalarSoftware "$dependencias"
    }

    configurar_python3() {
        echo -e "$VE Preparando configuracion de$RO Python3$CL"
        echo -e "$VE Instalando dependencias para Python 3$CL"

        local dependencias='python3-dev python3-flake8 python3-frozendict python3-future python3-ipython python3-mccabe python3-mysqldb python3-pep8 python3-pep8-naming python3-pip python3-pylama python3-powerline python3-powerline-taskwarrior python3-pycodestyle python3-pyflakes python3-setuptools python3-virtualenv'

        instalarSoftware "$dependencias"
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
