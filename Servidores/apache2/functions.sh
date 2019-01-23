#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://.fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
##

############################
##        FUNCIONES       ##
############################
##
## Borra todo el contenido dentro de /var/www
##
limpiarWWW() {
    sudo systemctl stop apache2

    echo -e "$VE Cuidado, esto puede$RO BORRAR$VE algo valioso$RO"
    read -p " ¿Quieres borrar todo el directorio /var/www/? s/N → " input

    ## TODO → Controlar si es Debian, Fedora o Gentoo (Cambia la ruta).

    if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
        sudo rm -R /var/www/*
    else
        echo -e "$VE No se borra$RO /var/www$CL"
    fi
}
