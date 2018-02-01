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

###########################
##       FUNCIONES       ##
###########################

atom_preconfiguracion() {
    echo -e "$VE Se va a instalar$RO Atom IDE$CL"
    if [[ ! -d "$HOME/.atom" ]]; then
        echo -e "$VE Se crea directorio $HOME/.atom$CL"
        mkdir "$HOME/.atom"
    else
        echo -e "$AM    ----------------------------$CL"
        echo -e "$VE Puedes limpiar$RO Atom Completamente$AM"
        read -p '¿Quieres borrar toda la configuración existente? s/N → ' input
        if [[ $input = 's' ]] || [[ $input = 'S' ]]; then
            echo -e "$RO →Borrando configuración vieja←$CL"
            rm -R "$HOME/.atom"
            mkdir "$HOME/.atom"
        fi
    fi

    if [[ ! -h "$HOME/.atom/config.cson" ]]; then
        enlazarHome '.atom/config.cson'
    fi

    if [[ ! -h "$HOME/.atom/keymap.cson" ]]; then
        enlazarHome '.atom/keymap.cson'
    fi

    if [[ ! -h "$HOME/.atom/snippets.cson" ]]; then
        enlazarHome '.atom/snippets.cson'
    fi

    if [[ ! -d "$HOME/.atom/Diccionarios" ]]; then
        descargarGIT 'Diccionarios' 'git://github.com/titoBouzout/Dictionaries.git' "$HOME/.atom/Diccionarios"
    fi
}

atom_postconfiguracion() {
    echo -e "$VE Añadiendo Post-Configuraciones para$RO Atom$CL"

    echo -e "$VE Deshabilitando complementos$CL"
    apm disable welcome
    apm disable about
}

atom_plugins() {
    ## Lista con paquetes ATOM
    local atom=$(cat $WORKSCRIPT/Apps/Atom_Paquetes.lst)

    ## Si se ha instalado correctamente ATOM, instalamos sus plugins
    echo -e "$VE Preparando instalación complementos$RO Atom$CL"
    if [[ -f '/usr/bin/atom' ]]; then
        for p in $atom; do
            ## Comprobación si existe instalado el complemento
            if [[ -d "$HOME/.atom/packages/$p" ]]; then
                echo -e "$AM Ya se encuentra instalado →$RO $p"
            else
                echo -e "$VE Instalando$RO $p $AM"
                apm install $p
            fi
        done
    fi
}

## Instala complementos para Atom IDE
atom_instalador() {
    instalar() {
        descargar "atom.deb" "https://atom.io/download/deb"
        instalarSoftwareDPKG "$WORKSCRIPT/tmp/atom.deb"
    }

    ## Preparando configuración de Atom
    atom_preconfiguracion

    ## Comprueba si está Atom instalado
    if [[ -f '/usr/bin/atom' ]]; then
        echo -e "$VE Ya esta$RO ATOM$VE instalado en el equipo, omitiendo paso$CL"
    else
        ## Comprobar si está descargado o descargar
        if [[ -f "$WORKSCRIPT/tmp/atom.deb" ]]; then
            echo -e "$VE Instalando$RO Atom $CL"
            instalarSoftwareDPKG "$WORKSCRIPT/tmp/atom.deb"

            ## Si falla la instalación se rellama la función tras limpiar
            if [[ ! -f '/usr/bin/atom' ]]; then
                rm -f "$WORKSCRIPT/tmp/atom.deb"
                instalar
            fi
        else
            instalar
        fi
    fi

    ## Instalar Plugins
    atom_plugins

    ## Añadir Configuraciones tras instalar
    atom_postconfiguracion
}
