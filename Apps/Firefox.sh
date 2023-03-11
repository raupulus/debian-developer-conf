#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Descarga e instala las versiones de firefox (nightly y developer) solo
## para el usuario actual que ha ejecutado el script

############################
##       FUNCIONES        ##
############################

## Instalar versiones de Firefox
firefox_instalador() {
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
            tar -xjvf "$WORKSCRIPT/tmp/Firefox-Developer.tar.bz2" -C "$WORKSCRIPT/tmp/Firefox-Developer" 2>> /dev/null

            ## Limpia destinos
            rm -Rf "$HOME/.local/opt/Firefox_Developer"
            rm -Rf "$HOME/.local/bin/firefox-developer"
            rm -Rf "$HOME/.local/share/applications/firefox-developer.desktop"

            ## Mover archivo extraido a su ubicación final
            mv "$WORKSCRIPT/tmp/Firefox-Developer/firefox" "$HOME/.local/opt/Firefox_Developer" 2>> /dev/null

            ## Crear enlaces de usuario y permisos de ejecución
            echo "$HOME/.local/opt/Firefox_Developer/firefox - P Firefox-Developer" > "$HOME/.local/bin/firefox-developer"
            chmod +x "$HOME/.local/bin/firefox-developer"

            ## Copiar acceso directo
            cp "$WORKSCRIPT/Accesos_Directos/firefox-developer.desktop" "$HOME/.local/share/applications/" 2>> /dev/null
        }

        if [[ -f "$HOME/.local/opt/Firefox_Developer/firefox" ]] &&
           [[ -f "$HOME/.local/bin/firefox-developer" ]] &&
           [[ -f "$HOME/.local/share/applications/firefox-developer.desktop" ]]
        then
            echo -e "$VE Ya esta$RO Firefox Developer$VE instalado en el equipo, omitiendo paso$CL"
        ## Comprueba que no está el archivo descargado en este directorio
        elif [[ ! -f "$WORKSCRIPT/tmp/Firefox-Developer.tar.bz2" ]]; then
            local REINTENTOS=20

            echo -e "$VE Descargando$RO Firefox Developer$CL"
            for (( i=1; i<=$REINTENTOS; i++ )); do
                rm "$WORKSCRIPT/tmp/Firefox-Developer.tar.bz" 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=es-ES' -O "$WORKSCRIPT/tmp/Firefox-Developer.tar.bz2" && break
            done
            echo -e "$VE Preparando para instalar$RO Firefox Developer Edition$CL"

            instalar
        else
            instalar
        fi
    }

    ## Firefox Nightly
    firefox_nightly() {

        instalar() {
            ## Desempaquetar Firefox-Nightly.tar.bz2
            mkdir -p "$WORKSCRIPT/tmp/Firefox-Nightly" 2>> /dev/null
            tar -xjvf "$WORKSCRIPT/tmp/Firefox-Nightly.tar.bz2" -C "$WORKSCRIPT/tmp/Firefox-Nightly" 2>> /dev/null

            ## Limpia destinos
            rm -Rf "$HOME/.local/opt/Firefox-Nightly"
            rm -Rf "$HOME/.local/bin/firefox-nightly"
            rm -Rf "$HOME/.local/share/applications/firefox-nightly.desktop"

            ## Mover archivo extraido a su ubicación final
            mv "$WORKSCRIPT/tmp/Firefox-Nightly/firefox" "$HOME/.local/opt/Firefox_Nightly" 2>> /dev/null

            ## Crear enlaces de usuario y permisos de ejecución
            echo "$HOME/.local/opt/Firefox_Nightly/firefox - P Firefox-Nightly" > "$HOME/.local/bin/firefox-nightly"
            chmod +x "$HOME/.local/bin/firefox-nightly" 2>> /dev/null

            ## Acceso directo Desktop
            cp -R "$WORKSCRIPT/Accesos_Directos/firefox-nightly.desktop" "$HOME/.local/share/applications/"

            ## Crear Perfil para Firefox
            if [[ -f "$HOME/.local/opt/Firefox_Nightly/firefox" ]]; then
                ## Crear perfil para Firefox-Developer
                "$HOME/.local/opt/Firefox_Nightly/firefox" -createprofile 'Firefox-Developer'
                ## Crear perfil para Firefox-Nightly
                "$HOME/.local/opt/Firefox_Nightly/firefox" -createprofile 'Firefox-Nightly'
            fi
        }

        if [[ -f "$HOME/.local/opt/Firefox_Nightly/firefox" ]] &&
           [[ -f "$HOME/.local/bin/firefox-nightly" ]] &&
           [[ -f "$HOME/.local/share/applications/firefox-nightly.desktop" ]]
        then
            echo -e "$VE Ya esta$RO Firefox Nightly$VE instalado en el equipo, omitiendo paso$CL"
        elif [[ ! -f "$WORKSCRIPT/tmp/Firefox-Nightly.tar.bz2" ]]; then
            local REINTENTOS=10

            echo -e "$VE Descargando$RO Firefox Nightly$CL"
            for (( i=1; i<=$REINTENTOS; i++ )); do
                rm "$WORKSCRIPT/tmp/Firefox-Nightly.tar.bz2" 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-nightly-latest-l10n-ssl&os=linux64&lang=es-ES' -O "$WORKSCRIPT/tmp/Firefox-Nightly.tar.bz2" && break
            done
            echo -e "$VE Preparando para instalar$RO Firefox Nightly$CL"

            instalar
        else
            instalar
        fi
    }

    ## Instalar Versiones de Firefox
    firefox_developer
    firefox_nightly

    exit 1
}
