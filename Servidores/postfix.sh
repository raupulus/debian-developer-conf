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
##

############################
##        FUNCIONES       ##
############################

postfix_descargar() {
    echo -e "$VE Descargando$RO postfix$CL"
}

postfix_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO postfix"
}

postfix_instalar() {
    echo -e "$VE Instalando$RO postfix$CL"
    local software=''
    instalarSoftware "$software"
}

postfix_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de postfix$CL"

}

postfix_instalador() {
    postfix_descargar
    postfix_preconfiguracion
    postfix_instalar

    ## Reiniciar servidor postfix para aplicar configuración
    reiniciarServicio postfix
}
