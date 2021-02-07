#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/Bash_Style_Guide

############################
##      INSTRUCTIONS      ##
############################
## Instala tmux de forma global al sistema y lo configura para el usuario que
## ha ejecutado el script generando perfil de color, correccion de sintaxis y
## un conjunto de plugins (incluido vundle) para trabajar con los principales
## lenguajes de progamación que utilizo.
## Al terminar instala y habilita todos los complementos.

############################
##       FUNCIONES        ##
############################
tmux_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO tmux$CL"
}

tmux_instalar() {
    echo -e "$VE Preparando para instalar$RO tmux$CL"
    instalarSoftwareLista "$SOFTLIST/Apps/tmux.lst"
}

tmux_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO tmux$CL"
    enlazarHome '.tmux.conf'
}

tmux_Instalador() {
    echo -e "$VE Comenzando instalación de$RO tmux$CL"

    tmux_preconfiguracion

    tmux_instalar
    tmux_postconfiguracion
}
