#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2020 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Descarga el IDE de Android

############################
##       FUNCIONES        ##
############################

android_studio_descargar() {
    local url="${1}"
    descargar "android_studio.tar.gz" "${url}"
}

android_studio_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Android Studio$CL"
    if [[ -d "$HOME/.local/opt/android_studio" ]]; then
        rm -Rf "$HOME/.local/opt/android_studio"
    fi

    if [[ -h "$HOME/.local/bin/android_studio" ]]; then
        rm -f "$HOME/.local/bin/android_studio"
    fi
}

android_studio_instalar() {
    echo -e "$VE Instalando$RO Android Studio$CL"
    echo -e "$VE Extrayendo IDE$CL"

    cd "$WORKSCRIPT/tmp/" || return 0

    tar -xvzf "android_studio.tar.gz" 2>> /dev/null

    if [[ -d "$WORKSCRIPT/tmp/android-studio" ]]; then
        mv "$WORKSCRIPT/tmp/android-studio" "$HOME/.local/opt/android_studio"
    fi

    cd "$WORKSCRIPT" || exit 1
}

android_studio_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Android Studio$CL"

    echo -e "$VE Generando comando$RO Android Studio$CL"
    ln -s "$HOME/.local/opt/android_studio/bin/studio.sh" "$HOME/.local/bin/android_studio"
}

android_studio_instalador() {
    echo -e "$VE Comenzando instalación de$RO Android Studio$CL"
    local url='https://r1---sn-h5q7rn7s.gvt1.com/edgedl/android/studio/ide-zips/3.6.2.0/android-studio-ide-192.6308749-linux.tar.gz?cms_redirect=yes&mh=gl&mm=28&mn=sn-h5q7rn7s&ms=nvh&mt=1585862242&mv=u&mvi=0&pl=24&shardbypass=yes'

    android_studio_preconfiguracion

    if [[ -f "$HOME/.local/bin/android_studio" ]] &&
       [[ -d "$HOME/.local/opt/android_studio" ]]
    then
        echo -e "$VE Ya esta$RO Android Studio$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/${url}-linux64.tar.xz" ]]; then
            android_studio_instalar "url" || rm -Rf "$WORKSCRIPT/tmp/android_studio.tar.gz"
        else
            android_studio_descargar "$url"
            android_studio_instalar
        fi
    fi

    android_studio_postconfiguracion
}
