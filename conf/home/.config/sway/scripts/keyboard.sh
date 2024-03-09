#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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
