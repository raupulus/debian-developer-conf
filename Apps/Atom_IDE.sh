#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

############################
##   Constantes Colores   ##
############################
amarillo="\033[1;33m"
azul="\033[1;34m"
blanco="\033[1;37m"
cyan="\033[1;36m"
gris="\033[0;37m"
magenta="\033[1;35m"
rojo="\033[1;31m"
verde="\033[1;32m"

#############################
##   Variables Generales   ##
#############################
atom=$(cat $PWD/Apps/Atom_Paquetes.lst) # Instala Paquetes de Atom
DIR_SCRIPT=`echo $PWD`

function atom_preconfiguracion() {
    echo ""
    echo -e "$verde Se va a instalar$rojo Atom IDE$gris"
    echo -e "$verde Puedes añadir configuraciones$amarillo"
    read -p '¿Quieres configuraciones? y/N → ' input
    if [ $input = 's' ] || [ $input = 'S' ] || [ $input = 'y' ] || [ $input = 'Y' ]
    then
        echo -e "$verde Creando Backup de ~/.atom$gris"
        cp -R $HOME/.atom $HOME/.atom.BACKUP 2>> /dev/null
        echo -e "$verde Añadiendo configuración nueva"
        cp -R $DIR_SCRIPT/Apps/.atom $HOME/
    fi
}

function atom_postconfiguracion() {
    echo -e "$verde Añadiendo configuraciones para Atom"

    echo -e "$verde Deshabilitando complementos"
    apm disable welcome
    apm disable about
}

function atom_plugins() {
    # Si se ha instalado correctamente ATOM pues instalamos sus plugins
    echo -e "$verde Preparando instalación complementos$rojo Atom$gris"
    if [ -f /usr/bin/atom ]
    then
        for p in $atom
        do
            # Comprobación si existe instalado el complemento
            if [ -d "$HOME/.atom/packages/$p" ]
            then
                echo -e "$amarillo Ya se encuentra instalado →$rojo $p"
            else
                echo -e "$verde Instalando$rojo $p $amarillo"
                apm install $p
            fi
        done
    fi
}

# Instala complementos para Atom IDE
function atom_instalador() {
    function instalar() {
        REINTENTOS=5
        echo -e "$verde Descargando$rojo ATOM$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm $DIR_SCRIPT/TMP/atom.deb 2>> /dev/null
            wget https://atom.io/download/deb -O $DIR_SCRIPT/TMP/atom.deb && break
        done
        echo -e "$verde Instalando$rojo Atom $gris"
        sudo dpkg -i $DIR_SCRIPT/TMP/atom.deb && sudo apt install -f -y
    }

    # Comprueba si está instalado
    if [ -f /usr/bin/atom ]
    then
        echo -e "$verde Ya esta$rojo ATOM$verde instalado en el equipo, omitiendo paso$gris"
    else
        # Preparando configuración de Atom
        atom_preconfiguracion

        # Comprobar si está descargado o descargar
        if [ -f $DIR_SCRIPT/TMP/atom.deb ]
        then
            echo -e "$verde Instalando$rojo Atom $gris"
            sudo dpkg -i $DIR_SCRIPT/TMP/atom.deb && sudo apt install -f -y

            # Si falla la instalación se rellama la función tras limpiar
            if [ ! -f /usr/bin/atom ]
            then
                rm -f $DIR_SCRIPT/TMP/atom.deb
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
