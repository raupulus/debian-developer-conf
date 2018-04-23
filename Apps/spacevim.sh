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
## Este script instala SpaceVim desde su sitio oficial

############################
##       FUNCIONES        ##
############################
spacevim_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Space Vim$CL"

    ## Si el directorio de configuración para vim es un enlace, se quita
    if [[ -h "$HOME/.vim" ]]; then
        rm -f "$HOME/.vim"
    fi

    ## Si el archivo de configuración para vim es un enlace, se quita
    if [[ -h "$HOME/.vimrc" ]]; then
        rm -f "$HOME/.vimrc"
    fi
}

spacevim_instalar() {
    echo -e "$VE Preparando para instalar$RO Space Vim$CL"
    curl -sLf 'https://spacevim.org/install.sh' | bash
}

spacevim_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Space Vim$CL"
}

spacevim_Instalador() {
    echo -e "$VE Comenzando instalación de$RO Space Vim$CL"

    spacevim_preconfiguracion
    spacevim_instalar
    spacevim_postconfiguracion
}
