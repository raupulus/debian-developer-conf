#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################
## Instala NodeJS, su gestor de paquetes NPM y además una serie de paquetes
## globales para corrección de sintaxis entre otras utilidades.

############################
##        FUNCIONES       ##
############################

nodejs_descargar() {
    echo -e "$VE Descargando$RO NodeJS$CL"
}

nodejs_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO NodeJS$CL"

    echo -e "$VE Generando directorios para$RO npm$VE en el home del usuario$CL"
    if [[ ! -d "$HOME/.npm/lib" ]]; then
        mkdir -p "$HOME/.npm/lib"
    fi

    if [[ ! -d "$HOME/.npm/bin" ]]; then
        mkdir -p "$HOME/.npm/bin"
    fi

    if [[ ! -d "$HOME/.npm/cache" ]]; then
        mkdir -p "$HOME/.npm/cache"
    fi
}

nodejs_instalar() {
    echo -e "$VE Instalando$RO NodeJS$CL"
    instalarSoftwareLista "${SOFTLIST}/Servidores/nodejs.lst"
}

nodejs_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO NodeJS$CL"

    echo -e "$VE Fijando$RO ~/.npm$VE como predeterminado$CL"
    npm config set prefix "$HOME/.npm"
    #npm config get prefix

    echo -e "$VE Fijando$RO ~/.npm/cache$VE como directorio para la$RO caché$CL"
    npm config set cache "$HOME/.npm/cache"
    #npm config get cache

    echo -e "$VE Exporto variables para usar$RO ~/.npm$CL"
    export NODE_PATH=~/.npm/lib/node_modules:$NODE_PATH
    export PATH=~/.npm/bin:$PATH

    ## Instalando paquetes globales
    local paquetes='eslint jscs compass stylelint typescript @ionic/cli http-server @typescript-eslint/eslint-plugin cordova-res cordova@latest eslint-plugin-html @vue/cli'
    instalarNpmGlobal $paquetes

    echo -e "$VE Instalando última versión de$RO npm$VE en directorio local$CL"
    instalarNpmGlobal npm
    npm --version

    npm update -g
}

nodejs_angular() {
    echo -e "$VE Instalando Angular$CL"
    instalarNpmGlobal @angular/cli
}

nodejs_instalador() {
    nodejs_descargar
    nodejs_preconfiguracion
    nodejs_instalar
    nodejs_postconfiguracion

    ## Se instalan paquetes adicionales
    nodejs_angular
}
