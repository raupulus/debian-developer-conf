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
## Instala y configura ohmyzsh para el usuario actual con el que se ha
## ejecutado el script. Añade personalizaciones y configuración para el
## archivo .zshrc en el home del usuario.

###########################
##       FUNCIONES       ##
###########################
ohmyzsh_descargar() {
    local REINTENTOS=5
    echo -e "$VE Descargando OhMyZSH$CL"
    for (( i=1; i<=$REINTENTOS; i++ )); do
        if [[ -d "$HOME/.oh-my-zsh" ]]; then
            rm -Rf "$HOME/.oh-my-zsh"
        fi

        ###TOFIX → Reparar script que sale mal: contraseña PAM y error (no continua por eso), por ello temporalmente siempre hay "break"
        curl -L 'http://install.ohmyz.sh' | sh && break || break
    done
}

ohmyzsh_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO ohmyzsh$CL"
}

ohmyzsh_instalar() {
    echo -e "$VE Instalar$RO OhMyZsh$CL"
    ## La instalación en este caso se hace al mismo tiempo de la descarga.
}

ohmyzsh_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO ohmyzsh$CL"

    local archivosConfiguracion='.zshrc .tmux.conf powerline dunst'

    ## Crea el backup y enlazar archivos de este repo
    enlazarHome "$archivosConfiguracion"

    ## Actualizando repositorio para OhMyZsh
    cd "$HOME/.oh-my-zsh/"
    git pull
    cd "$WORKSCRIPT"
}

ohmyzsh_Instalador() {
    echo -e "$VE Comenzando instalación de$RO ohmyzsh$CL"

    ohmyzsh_preconfiguracion

    if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
        echo -e "$VE Ya esta$RO ohmyzsh$VE instalado en el equipo, omitiendo paso$CL"
    else
        ohmyzsh_descargar
        ohmyzsh_instalar
    fi

    ohmyzsh_postconfiguracion
}
