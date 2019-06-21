#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

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
    enlazarHome '.pip'
}

python_instalar() {
    echo -e "$VE Instalando$RO Python y Django$CL"
    ## Instalar python y gestor de paquetes
    instalarSoftwareLista "$SOFTLIST/Lenguajes-Programacion/python.lst"
}

python_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de python"

    configurar_python2() {
        echo -e "$VE Preparando configuracion de$RO Python2$CL"
        instalarSoftwareLista "$SOFTLIST/Lenguajes-Programacion/python2.lst"

        python2Install 'python-language-server[all]' 'virtualenvwrapper' 'pip-review'
    }

    configurar_python3() {
        echo -e "$VE Preparando configuracion de$RO Python3$CL"
        echo -e "$VE Instalando dependencias para Python 3$CL"

        python3Install 'python-language-server[all]' 'virtualenvwrapper' 'pip-review'
    }

    personalizar_python2() {
        echo -e "$VE Personalizando$RO Python y Django$CL"
        ## Closure linter
        python2Install 'https://github.com/google/closure-linter/zipball/master'
    }

    personalizar_python3() {
        echo -e "$VE Personalizando$RO Python3$CL"
        ## Closure linter
        python3Install 'https://github.com/google/closure-linter/zipball/master'
    }

    configurar_python2
    configurar_python3
    personalizar_python2
    personalizar_python3

    ## Variable global que indica que instale los paquetes como usuario en home
    setVariableGlobal 'PIP_USER' 'y'
    source '/etc/environment'
}


python_instalador() {
    python_descargar
    python_preconfiguracion
    python_instalar
    python_postconfiguracion
}
