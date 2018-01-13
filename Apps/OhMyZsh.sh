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

ohMyZSH() {
    if [ -f ~/.oh-my-zsh/oh-my-zsh.sh ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo OhMyZSH$verde instalado para este usuario, omitiendo paso$gris"
    else
        REINTENTOS=5
        echo -e "$verde Descargando OhMyZSH$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            ###TOFIX → Reparar script que sale mal: contraseña PAM y error (no continua por eso)
            rm -R ~/.oh-my-zsh 2>> /dev/null
            curl -L http://install.ohmyz.sh | sh && break || break
        done
    fi
}

ohmyzsh_descargar() {
    echo ""
}

ohmyzsh_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO ohmyzsh$CL"
}

ohmyzsh_instalar() {
    echo -e "$VE Preparando para instalar$RO ohmyzsh$CL"
}

ohmyzsh_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO ohmyzsh$CL"

    local archivosConfiguracion='.zshrc .tmux.conf'

    ## Crear Backup
    crearBackup "$archivosConfiguracion"

    ## Enlazar archivos de este repo
    enlazarHome "$archivosConfiguracion"
}

ohmyzsh_instalador() {
    echo -e "$VE Comenzando instalación de$RO ohmyzsh$CL"

    ohmyzsh_preconfiguracion

    if [[ -f '$HOME/.oh-my-zsh/oh-my-zsh.sh' ]]; then
        echo -e "$VE Ya esta$RO ohmyzsh$VE instalado en el equipo, omitiendo paso$CL"
    else
        ohmyzsh_instalar
    fi

    ohmyzsh_postconfiguracion
}
