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
## Instala NodeJS, su gestor de paquetes NPM y además una serie de paquetes
## globales para corrección de sintaxis entre otras utilidades.

############################
##        FUNCIONES       ##
############################

nodejs_descargar() {
    echo -e "$VE Descargando$RO NodeJS$CL"
}

nodejs_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO NodeJS$CL"
}

nodejs_instalar() {
    echo -e "$VE Instalando$RO NodeJS$CL"
    instalarSoftware nodejs
    actualizarSoftware nodejs

    echo -e "$VE Instalando Dependencias para $RO NodeJS$CL"
    local dependencias='node-typescript'
    instalarSoftware "$dependencias"
}

nodejs_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de NodeJS$CL"

    ## Instalando paquetes globales
    local paquetes='eslint jscs bower compass stylelint bundled'
    instalarNpm $paquetes
}

nodejs_instalador() {
    nodejs_descargar
    nodejs_preconfiguracion
    nodejs_instalar
    nodejs_postconfiguracion
}
