#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Menú principal para instalar y configurar Servidores permitiendo
## elegir entre cada uno de ellos desde un menú o todos directamente
## en un proceso automatizado.

############################
##     IMPORTACIONES      ##
############################

###########################
##       FUNCTIONS       ##
###########################

##
## Genera la estructura de directorios para el usuario actual en su home.
##
generate_home_structure() {
    echo -e "$VE Generando$RO estructura de directorios$CL"

    dir_exist_or_create "$HOME/.local"
    dir_exist_or_create "$HOME/.local/bin"
    dir_exist_or_create "$HOME/.local/lib"
    dir_exist_or_create "$HOME/.local/opt"
    dir_exist_or_create "$HOME/.local/share"

    dir_exist_or_create "$HOME/.config"

    dir_exist_or_create "$HOME/Imágenes"
    dir_exist_or_create "$HOME/Imágenes/Screenshots"
}

##
## Instalar Todas las configuraciones
##
user_directories() {
    cd "$WORKSCRIPT" || exit 1

    generate_home_structure
}
