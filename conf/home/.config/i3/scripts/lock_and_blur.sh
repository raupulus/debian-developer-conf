#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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
## Antes de bloquear toma una captura de la pantalla y la difumina para luego
## usarla de fondo de pantalla en el bloqueador

############################
##       FUNCIONES        ##
############################
## Almaceno temporalmente captura de pantalla y establezco icono de bloqueo
icon="$HOME/.config/i3/images/lock.png"
tmpbg='/tmp/screen_lock_i3wm.png'

## Creo una captura del escritorio
scrot "$tmpbg"

## Aplico efecto blur a la imagen capturada
convert "$tmpbg" -filter Gaussian -thumbnail 20% -sample 500% "$tmpbg"

## Aplico el icono de bloqueo sobre la imagen de fondo
convert "$tmpbg" "$icon" -gravity center -composite "$tmpbg"

## Bloqueo la pantalla usando la imagen de fondo
i3lock -i "$tmpbg"
