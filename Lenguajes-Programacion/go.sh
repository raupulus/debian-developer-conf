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

go_descargar() {
    echo -e "$VE Descargando$RO go$CL"
}

go_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO go$CL"
}

go_instalar() {
    echo -e "$VE Instalando$RO go$CL"
    instalarSoftware 'golang-go'

    echo -e "$VE Instalando paquetes complementarios de$RO go$CL"
    local complementarios='gocode golint'
    instalarSoftware "$complementarios"
}

go_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO go$CL"
}

go_instalador() {
    go_descargar
    go_preconfiguracion
    go_instalar
    go_postconfiguracion
}
