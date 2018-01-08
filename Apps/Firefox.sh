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

    # Firefox Developer
    function firefox_developer() {

        function instalar() {
            # Desempaquetar Firefox-Developer_amd64.tar.bz2
            mkdir -p $DIR_SCRIPT/TMP/Firefox-Developer_amd64 2>> /dev/null
            tar -xjvf $DIR_SCRIPT/TMP/Firefox-Developer_amd64.tar.bz2 -C $DIR_SCRIPT/TMP/Firefox-Developer_amd64 2>> /dev/null

            # Mover archivo extraido a su ubicación final
            mv $DIR_SCRIPT/TMP/Firefox-Developer_amd64/firefox ~/.local/opt/Firefox_Developer 2>> /dev/null

            # Crear enlaces de usuario y permisos de ejecución
            echo "$HOME/.local/opt/Firefox_Developer/firefox - P Firefox-Developer" > ~/.local/bin/firefox-developer
            chmod +x ~/.local/bin/firefox-developer

            # Copiar acceso directo
            cp Accesos_Directos/firefox-developer.desktop ~/.local/share/applications/ 2>> /dev/null
        }

        if [ -f ~/.local/bin/firefox-developer ]
        then
            echo -e "$verde Ya esta$rojo Firefox Developer$verde instalado en el equipo, omitiendo paso$gris"
        # Comprueba que no está el archivo descargado en este directorio
    elif [ ! -f $DIR_SCRIPT/TMP/Firefox-Developer_amd64.tar.bz2 ]
        then
            REINTENTOS=50
            echo -e "$verde Descargando$rojo Firefox Developer$gris"
            for (( i=1; i<=$REINTENTOS; i++ ))
            do
                rm $DIR_SCRIPT/TMP/Firefox-Developer_amd64.tar.bz 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=es-ES' -O $DIR_SCRIPT/TMP/Firefox-Developer_amd64.tar.bz2 && break
            done
            echo -e "$verde Preparando para instalar$rojo Firefox Developer Edition$gris"

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
            if [ -f ~/.local/opt/Firefox_Nightly/firefox ]
            then
                # Crear perfil para Firefox-Developer
                ~/.local/opt/Firefox_Nightly/firefox -createprofile Firefox-Developer
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
