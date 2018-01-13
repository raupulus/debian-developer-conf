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

############################
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################
ohmyzsh_descargar() {
    local REINTENTOS=5
    echo -e "$VE Descargando OhMyZSH$CL"
    for (( i=1; i<=$REINTENTOS; i++ )); do
        ###TOFIX → Reparar script que sale mal: contraseña PAM y error (no continua por eso), por ello temporalmente siempre hay "break"
        rm -R "$HOME/.oh-my-zsh" 2>> /dev/null
        curl -L 'http://install.ohmyz.sh' | sh && break || break
    done
}

ohmyzsh_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO ohmyzsh$CL"
}

ohmyzsh_instalar() {
    echo -e "$VE Preparando para instalar$RO ohmyzsh$CL"
    ## La instalación en este caso se hace al mismo tiempo de la descarga.
}

ohmyzsh_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO ohmyzsh$CL"

    local archivosConfiguracion='.zshrc .tmux.conf'

    ## Crear Backup
    crearBackup "$archivosConfiguracion"

    ## Enlazar archivos de este repo
    enlazarHome "$archivosConfiguracion"

    ## Actualizando repositorio para OhMyZsh
    cd "$HOME/.oh-my-zsh/"
    git pull 2>> /dev/null
    cd "$WORKSCRIPT"
}

ohmyzsh_instalador() {
    echo -e "$VE Comenzando instalación de$RO ohmyzsh$CL"

    ohmyzsh_preconfiguracion

    if [[ -f '$HOME/.oh-my-zsh/oh-my-zsh.sh' ]]; then
        echo -e "$VE Ya esta$RO ohmyzsh$VE instalado en el equipo, omitiendo paso$CL"
    else
        ohmyzsh_descargar
        ohmyzsh_instalar
    fi

    ohmyzsh_postconfiguracion
}
