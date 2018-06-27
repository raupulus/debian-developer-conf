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
## Plantea la instalación de Openbox con las configuraciones

############################
##       FUNCIONES        ##
############################
openbox_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO openbox$CL"
}

openbox_instalar() {
    echo -e "$VE Preparando para instalar$RO openbox$CL"
    instalarSoftware openbox obconf-qt openbox-gnome-session openbox-menu
}

##
## Instalando software extra y configuraciones adicionales
##
openbox_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO openbox$CL"

    echo -e "$VE Instalando software secundario$CL"
    #instalarSoftware suckless-tools

    echo -e "$VE Generando archivos de configuración$CL"
    #enlazarHome '.config/.openbox'
}

openbox_instalador() {
    echo -e "$VE Comenzando instalación de$RO openbox$CL"

    openbox_preconfiguracion
    openbox_instalar
    openbox_postconfiguracion
}
