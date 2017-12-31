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
## Este script tiene como objetivo ofrecer funciones recurrentes de
## forma auxiliar para todos los demás scripts.

###########################
##       FUNCIONES       ##
###########################
##
## Crea un respaldo del archivo o directorio pasado como parámetro
## @param  $*  Recibe una serie de elementos a los que crearle un backup
##
crearBackup() {
    ## Crear directorio Backups si no existiera
    if [[ ! -d "$WORKSCRIPT/Backups" ]]; then
        mkdir $WORKSCRIPT/Backups
    fi

    for salvando in $*; do
        if [[ -f $salvando ]]; then
            echo "Creando Backup del archivo $salvando"
            cp "$salvando" "$WORKSCRIPT/Backups/"
        elif [[ -d $salvando ]]; then
            echo "Creando Backup del directorio $salvando"
            cp -R "$salvando" "$WORKSCRIPT/Backups/"
        else
            echo "No se encuentra $salvando"
        fi
    done
}

##
## Muestra el texto recibido como parámetro formateado por pantalla
## @param  $1  String  Recibe la cadena a pintar
##
opciones() {
    echo -e "$AZ Opciones Disponibles$CL"
    echo -e "$VE $1$CL"
}

##
## Recibe uno o más parámetros con el nombre de los programas a instalar
## @param  $*  String  Nombre de programas a instalar
##
instalarSoftware() {
    for programa in $*; do
        sudo dnf install -y "$programa"
    done
}

##
## Descarga desde el lugar pasado como segundo parámetro y lo guarda con el
## nombre del primer parámetro dentro del directorio temporal "tmp" de este
## repositorio, quedando excluido del mismo control de versiones.
## @param  $1  String  Nombre del recurso a descargar (Añadir extensión)
## @param  $2  String  Origen de la descarga (Desde donde descargar)
##
descargar() {
    ## TODO:
    ## Comprobar que se reciben 3 parámetros
    ## Comprobar que no son cadenas vacías
    ## Comprobar que no son números

    ## Crear directorio Temporal si no existiera
    if [[ ! -d "$WORKSCRIPT/tmp" ]]; then
        mkdir $WORKSCRIPT/tmp
    fi

    echo -e "$VE Descargando$RO $1 $CL"
    local REINTENTOS=10
    for (( i=1; i<=$REINTENTOS; i++ )); do
        rm $WORKSCRIPT/tmp/$1 2>> /dev/null
        wget --show-progress "$2" -O "$WORKSCRIPT/tmp/$1" && break
    done
}

##
## Recibe un nombre, el repositorio de origen y el directorio destino para
## descargar el repositorio controlando errores y reintentando cuando falle.
## @param  $1  String  Nombre, es más para informar y registrar log
## @param  $2  String  Repositorio desde donde descargar
## @param  $3  String  Lugar donde guardamos el repositorio
##
descargarGIT() {
    local reintentos=10
    echo -e "$VE Descargando $RO$1$VE desde Repositorio$RO GIT$CL"
    if [[ ! -d "$3" ]]; then
        for (( i=1; i<=$reintentos; i++ )); do
            echo -e "$VE Descargando$RO $1$VE, intento$RO $i$CL"
            if [[ $i -eq $reintentos ]]; then
                rm -R "$3" 2>> /dev/null
                break
            fi
            git clone "$2" "$3" && break
            rm -R "$3" 2>> /dev/null
        done
    else
        echo -e "$RO$1$VE ya está instalado$CL"
        echo -e "$VE Se actualizará el repositorio existente de$RO $1$CL"
        cd "$3"
        git pull origin master
        cd "$WORKSCRIPT"
    fi
}
##
## Crea un enlace por archivo pasado después de realizar una copia de seguridad ## tomando como punto de referencia el propio repositorio, ruta conf/home/
## donde estarán situado todos los archivos para ser actualizados con
## el repositorio.
## @param  $*  String  Nombre del archivo o directorio dentro del home del user
##
enlazarHome() {
    for x in $*; do
        echo -e "$VE Creando enlace de$RO $x$CL"

        if [[ -h "$HOME/$x" ]]; then  ## Si es un enlace
            echo -e "$VE Limpiando enlace anterior para$RO $x$CL"
            rm "$HOME/$x"
        elif [[ -f "$HOME/$x" ]] &&   ## Si es un archivo y no tiene backup
             [[ ! -f "$WORKSCRIPT/Backups/$x" ]]; then
            echo -e "$VE Creando enlace para el archivo$RO $HOME$x$CL"
            crearBackup "$HOME/$x" && rm "$HOME/$x"
        elif [[ -d "$HOME/$x" ]] &&   ## Si es un directorio y no tiene backup
             [[ ! -d "$WORKSCRIPT/Backups/$x" ]]; then
            echo -e "$VE Creando enlace para el directorio$RO $HOME$x$CL"
            crearBackup "$HOME/$x" && rm -R "$HOME/$x"
        else
            echo -e "$VE Eliminando $RO$HOME/$x$VE, ya existe$RO Backup$CL"
            rm "$HOME/$x"
        fi

        ln -s "$WORKSCRIPT/conf/home/$x" "$HOME/$x"
    done
}
