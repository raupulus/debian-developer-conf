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
DIR_SCRIPT=`echo $PWD`

# Instalar versiones de Firefox
function firefox_install() {

    # Si no existen los directorios se crearán
    if [ ! -d ~/.local/opt ]
    then
        mkdir -p ~/.local/opt
    fi

    if [ ! -d ~/.local/bin ]
    then
        mkdir -p ~/.local/bin
    fi

    if [ ! -d ~/.local/share/applications ]
    then
        mkdir -p ~/.local/share/applications
    fi

    # Firefox Quantum Developer Edition
    function firefox_developer() {

        function instalar() {
            # Desempaquetar Firefox-Quantum_amd64.tar.bz2
            mkdir -p $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64 2>> /dev/null
            tar -xjvf $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64.tar.bz2 -C $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64 2>> /dev/null

            # Mover archivo extraido a su ubicación final
            mv $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64/firefox ~/.local/opt/Firefox_Quantum_Developer 2>> /dev/null

            # Crear enlaces de usuario y permisos de ejecución
            echo "$HOME/.local/opt/Firefox_Quantum_Developer/firefox - P Firefox-Quantum" > ~/.local/bin/firefox-quantum
            # ln -s ~/.local/opt/Firefox_Quantum_Developer/firefox ~/.local/bin/firefox-quantum 2>> /dev/null
            chmod +x ~/.local/bin/firefox-quantum

            # Copiar acceso directo
            cp Accesos_Directos/firefox-quantum.desktop ~/.local/share/applications/ 2>> /dev/null
        }

        if [ -f ~/.local/bin/firefox-quantum ]
        then
            echo -e "$verde Ya esta$rojo Firefox Quantum Developer Edition$verde instalado en el equipo, omitiendo paso$gris"
        # Comprueba que no está el archivo descargado en este directorio
    elif [ ! -f $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64.tar.bz2 ]
        then
            REINTENTOS=50 actualizados, 0 nuevos se instalarán, 0 para eliminar y 4
            echo -e "$verde Descargando$rojo Firefox Quantum Developer Edition$gris"
            for (( i=1; i<=$REINTENTOS; i++ ))
            do
                rm $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64.tar.bz 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=es-ES' -O $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64.tar.bz2 && break
            done
            echo -e "$verde Preparando para instalar$rojo Firefox Quantum Developer Edition$gris"

            instalar
        else
            instalar
        fi
    }

    # Firefox Nightly
    function firefox_nightly() {

        function instalar() {
             # Desempaquetar Firefox-Nightly_amd64.tar.bz2
            mkdir -p $DIR_SCRIPT/TMP/Firefox-Nightly_amd64 2>> /dev/null
            tar -xjvf $DIR_SCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 -C $DIR_SCRIPT/TMP/Firefox-Nightly_amd64 2>> /dev/null

            # Mover archivo extraido a su ubicación final
            mv $DIR_SCRIPT/TMP/Firefox-Nightly_amd64/firefox ~/.local/opt/Firefox_Nightly 2>> /dev/null

            # Crear enlaces de usuario y permisos de ejecución
            echo "~/.local/opt/Firefox_Nightly/firefox - P Firefox-Nightly" > ~/.local/bin/firefox-nightly
            chmod +x ~/.local/bin/firefox-nightly 2>> /dev/null

            # Acceso directo Desktop
            cp -R Accesos_Directos/firefox-nightly.desktop ~/.local/share/applications/

            # Crear Perfil para Firefox
            if [ -f ~/.local/opt/firefox-nightly/firefox ]
            then
                # Crear perfil para Firefox-Quantum
                ~/.local/opt/Firefox_Nightly/firefox -createprofile Firefox-Quantum
                # Crear perfil para Firefox-Nightly
                ~/.local/opt/Firefox_Nightly/firefox -createprofile Firefox-Nightly
            fi
        }


        if [ -f ~/.local/bin/firefox-nightly ]
        then
            echo -e "$verde Ya esta$rojo Firefox Nightly$verde instalado en el equipo, omitiendo paso$gris"
        elif [ ! -f $DIR_SCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 ]
        then
            REINTENTOS=3
            echo -e "$verde Descargando$rojo Firefox Nightly$gris"
            for (( i=1; i<=$REINTENTOS; i++ ))
            do
                rm $DIR_SCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-nightly-latest-l10n-ssl&os=linux64&lang=es-ES' -O $DIR_SCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 && break
            done
            echo -e "$verde Preparando para instalar$rojo Firefox Nightly$gris"

            instalar
        else
            instalar
        fi
    }

    # Instalar Versiones de Firefox
    firefox_developer
    firefox_nightly
}
