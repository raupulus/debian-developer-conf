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
## Plantea la instalación de i3wm con las configuraciones

############################
##       FUNCIONES        ##
############################
i3wm_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO i3wm$CL"
}

i3wm_instalar() {
    echo -e "$VE Preparando para instalar$RO i3wm$CL"
    sudo apt install i3-wm i3-blocks suckless-tools
}

##
## Instalando software extra y configuraciones adicionales
##
i3wm_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO i3wm$CL"
    sudo apt install rxvt-unicode-256color compton compton-conf compton-conf-l10n nitrogen gpicview thunar ranger w3m tint2 arandr neofetch
}

i3wm_instalador() {
    echo -e "$VE Comenzando instalación de$RO i3wm$CL"

    i3wm_preconfiguracion
    i3wm_instalar
    i3wm_postconfiguracion
}
