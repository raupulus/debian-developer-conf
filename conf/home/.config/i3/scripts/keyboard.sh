#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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
## Conmuta entre distintas opciones de teclados predefinidas

############################
##       VARIABLES        ##
############################
## Almaceno el idioma actual
idiomaActual=$(setxkbmap -print | grep xkb_symbols | awk '{print $4}' | awk -F"+" '{print $2}')

############################
##       FUNCIONES        ##
############################
## Compruebo el teclado actual
if [[ "$idiomaActual" = 'es' ]]; then
    setxkbmap -layout us -variant dvp
elif [[ "$idiomaActual" = 'us(dvp)' ]]; then
    setxkbmap es
else
    setxkbmap es
fi

## Almaceno de nuevo el idioma actual
idiomaActual=$(setxkbmap -print | grep xkb_symbols | awk '{print $4}' | awk -F"+" '{print $2}')

## Nofitico del teclado actual
notify-send "Teclado actual: $idiomaActual"

exit 0
