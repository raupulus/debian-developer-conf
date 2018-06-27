#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

c_descargar() {
    echo -e "$VE Descargando$RO C$VE y$RO C++$CL"
}

c_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO C$VE y$RO C++$CL"
}

c_instalar() {
    echo -e "$VE Instalando$RO C$VE y$RO C++$CL"
    instalarSoftware 'cmake'

    echo -e "$VE Instalando paquetes complementarios de$RO C$VE y$RO C++$CL"
    local complementarios=''
    instalarSoftware "$complementarios"
}

c_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO C$VE y$RO C++$CL"
}

c_instalador() {
    c_descargar
    c_preconfiguracion
    c_instalar
    c_postconfiguracion
}
