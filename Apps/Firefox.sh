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

## Instalar versiones de Firefox
firefox_install() {

    # Si no existen los directorios dentro del usuario, se crearán
    if [[ ! -d "$HOME/.local/opt" ]]; then
        mkdir -p "$HOME/.local/opt"
    fi

    if [[ ! -d "$HOME/.local/bin" ]]; then
        mkdir -p "$HOME/.local/bin"
    fi

    if [[ ! -d "$HOME/.local/share/applications" ]]; then
        mkdir -p "$HOME/.local/share/applications"
    fi

    ## Firefox Developer
    firefox_developer() {

        instalar() {
            ## Desempaquetar Firefox-Developer_amd64.tar.bz2
            mkdir -p "$WORKSCRIPT/tmp/Firefox-Developer" 2>> /dev/null
            tar -xjvf "$WORKSCRIPT/tmp/Firefox-Developer.tar.bz2" -C "$WORKSCRIPT/tmp/Firefox-Developer_amd64" 2>> /dev/null

            ## Mover archivo extraido a su ubicación final
            mv $WORKSCRIPT/TMP/Firefox-Developer_amd64/firefox ~/.local/opt/Firefox_Developer 2>> /dev/null

            ## Crear enlaces de usuario y permisos de ejecución
            echo "$HOME/.local/opt/Firefox_Developer/firefox - P Firefox-Developer" > "$HOME/.local/bin/firefox-developer"
            chmod +x "$HOME/.local/bin/firefox-developer"

            ## Copiar acceso directo
            cp "$WORKSCRIPT/Accesos_Directos/firefox-developer.desktop" "$HOME/.local/share/applications/" 2>> /dev/null
        }

        if [[ -f "$HOME/.local/bin/firefox-developer" ]]; then
            echo -e "$verde Ya esta$rojo Firefox Developer$verde instalado en el equipo, omitiendo paso$gris"
        ## Comprueba que no está el archivo descargado en este directorio
        elif [[ ! -f "$WORKSCRIPT/tmp/Firefox-Developer.tar.bz2" ]]; then
            local REINTENTOS=20

            echo -e "$verde Descargando$rojo Firefox Developer$gris"
            for (( i=1; i<=$REINTENTOS; i++ )); do
                rm "$WORKSCRIPT/tmp/Firefox-Developer.tar.bz" 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=es-ES' -O "$WORKSCRIPT/TMP/Firefox-Developer.tar.bz2" && break
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
            mkdir -p $WORKSCRIPT/TMP/Firefox-Nightly_amd64 2>> /dev/null
            tar -xjvf $WORKSCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 -C $WORKSCRIPT/TMP/Firefox-Nightly_amd64 2>> /dev/null

            # Mover archivo extraido a su ubicación final
            mv $WORKSCRIPT/TMP/Firefox-Nightly_amd64/firefox ~/.local/opt/Firefox_Nightly 2>> /dev/null

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
        elif [ ! -f $WORKSCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 ]
        then
            REINTENTOS=3
            echo -e "$verde Descargando$rojo Firefox Nightly$gris"
            for (( i=1; i<=$REINTENTOS; i++ ))
            do
                rm $WORKSCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-nightly-latest-l10n-ssl&os=linux64&lang=es-ES' -O $WORKSCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 && break
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
