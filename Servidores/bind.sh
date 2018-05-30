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
## Instala y configura bind 9 dejando el servicio desactivado.

############################
##        FUNCIONES       ##
############################

bind_descargar() {
    echo -e "$VE Descargando$RO Bind 9$CL"
}

bind_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Bind 9"
}

bind_instalar() {
    echo -e "$VE Instalando$RO Bind 9$CL"
    local programa='bind9'
    instalarSoftware "$programa"
}

bind_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de Bind 9$CL"

}

bind_instalador() {
    bind_descargar
    bind_preconfiguracion
    bind_instalar

    echo -e "$VE ¿Quieres el configurar de forma$RO interactiva$VE Bind9?$CL"
    read -p ' s/N → ' input
    if [[ "$input" == 's' ]] || [[ "$input" == 'S' ]]; then
        bind_postconfiguracion
    fi

    ## Reiniciar servidor BIND para aplicar configuración
    reiniciarServicio bind
}
