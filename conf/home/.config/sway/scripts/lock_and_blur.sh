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
## Antes de bloquear toma una captura de la pantalla y la difumina para luego
## usarla de fondo de pantalla en el bloqueador

############################
##       FUNCIONES        ##
############################
## Almaceno temporalmente captura de pantalla y establezco icono de bloqueo
icon="$HOME/.config/sway/images/lock.png"
tmpbg='/tmp/screen_lock_sway.png'

## Creo una captura del escritorio
grim "$tmpbg"
chmod ugo+rw "$tmpbg"

## Aplico efecto blur a la imagen capturada
convert "$tmpbg" -filter Gaussian -thumbnail 20% -sample 500% "$tmpbg"

## Aplico el icono de bloqueo sobre la imagen de fondo
convert "$tmpbg" "$icon" -gravity center -composite "$tmpbg"

## Bloqueo la pantalla usando la imagen de fondo
swaylock -C ~/.config/swaylock/config