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
## Plantea la instalación de gnome_shell con las configuraciones

############################
##       FUNCIONES        ##
############################
gnome_shell_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Gnome Shell$CL"
}

gnome_shell_instalar() {
    echo -e "$VE Preparando para instalar$RO Gnome Shell$CL"
    #instalarSoftware gnome_shell
}

##
## Instalando software extra y configuraciones adicionales
##
gnome_shell_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Gnome Shell$CL"

    echo -e "$VE Instalando software secundario$CL"
    #instalarSoftware ''

    echo -e "$VE Generando archivos de configuración$CL"
    #enlazarHome '.config/.gnome_shell'

    ## Compilar
    gnome_shell --recompile
}

gnome_shell_postconfiguracionOpcional() {
    echo -e "$VE Generando Post-Configuraciones Opcionales$RO Gnome Shell$CL"

    instalarSoftware 'gedit' 'gedit-plugins'
}

gnome_shell_instalador() {
    echo -e "$VE Comenzando instalación de$RO Gnome Shell$CL"

    gnome_shell_preconfiguracion
    gnome_shell_instalar
    gnome_shell_postconfiguracion
    gnome_shell_postconfiguracionOpcional
}
