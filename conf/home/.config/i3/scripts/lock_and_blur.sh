#!/usr/bin/env bash

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
