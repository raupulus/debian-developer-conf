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

atom=$(cat $WORKSCRIPT/Apps/Atom_Paquetes.lst)  ## Lista con paquetes ATOM

function atom_preconfiguracion() {
    echo ""
    echo -e "$VE Se va a instalar$rojo Atom IDE$CL"
    echo -e "$VE Puedes añadir configuraciones$AM"
    read -p '¿Quieres configuraciones? y/N → ' input
    if [ $input = 's' ] || [ $input = 'S' ] || [ $input = 'y' ] || [ $input = 'Y' ]
    then
        echo -e "$VE Creando Backup de ~/.atom$CL"
        cp -R $HOME/.atom $HOME/.atom.BACKUP 2>> /dev/null
        echo -e "$VE Añadiendo configuración nueva"
        cp -R $WORKSCRIPT/Apps/.atom $HOME/
    fi
}

function atom_postconfiguracion() {
    echo -e "$VE Añadiendo configuraciones para Atom"

    echo -e "$VE Deshabilitando complementos"
    apm disable welcome
    apm disable about
}

function atom_plugins() {
    # Si se ha instalado correctamente ATOM pues instalamos sus plugins
    echo -e "$VE Preparando instalación complementos$rojo Atom$CL"
    if [ -f /usr/bin/atom ]
    then
        for p in $atom
        do
            # Comprobación si existe instalado el complemento
            if [ -d "$HOME/.atom/packages/$p" ]
            then
                echo -e "$AM Ya se encuentra instalado →$rojo $p"
            else
                echo -e "$VE Instalando$rojo $p $AM"
                apm install $p
            fi
        done
    fi
}

# Instala complementos para Atom IDE
function atom_instalador() {
    function instalar() {
        REINTENTOS=5
        echo -e "$VE Descargando$rojo ATOM$CL"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm $WORKSCRIPT/TMP/atom.deb 2>> /dev/null
            wget https://atom.io/download/deb -O $WORKSCRIPT/TMP/atom.deb && break
        done
        echo -e "$VE Instalando$rojo Atom $CL"
        sudo dpkg -i $WORKSCRIPT/TMP/atom.deb && sudo apt install -f -y
    }

    # Comprueba si está instalado
    if [ -f /usr/bin/atom ]
    then
        echo -e "$VE Ya esta$rojo ATOM$VE instalado en el equipo, omitiendo paso$CL"
    else
        # Preparando configuración de Atom
        atom_preconfiguracion

        # Comprobar si está descargado o descargar
        if [ -f $WORKSCRIPT/TMP/atom.deb ]
        then
            echo -e "$VE Instalando$rojo Atom $CL"
            sudo dpkg -i $WORKSCRIPT/TMP/atom.deb && sudo apt install -f -y

            # Si falla la instalación se rellama la función tras limpiar
            if [ ! -f /usr/bin/atom ]
            then
                rm -f $WORKSCRIPT/TMP/atom.deb
                instalar
            fi
        else
            instalar
        fi
    fi

    # Instalar Plugins
    atom_plugins

    # Añadir Configuraciones tras instalar
    atom_postconfiguracion
}
