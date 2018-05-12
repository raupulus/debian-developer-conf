#!/bin/bash

## Captura de Pantalla
#bindsym Print exec scrot '%Y-%m-%d_%T_scrot.png' -e 'mv $f ~/Imágenes/Screenshots/'

## Captura de Ventana
#bindsym $mod+Control+Print exec scrot '%Y-%m-%d_%T_scrot.png' -u -e 'mv $f ~/Imágenes/Screenshots/'

## Capturar un área (No termina de funcionar correctamente)
#bindsym --release $mod+Control+Print exec --no-startup-id scrot -s '%Y-%m-%d_%T_scrot.png' -e 'mv $f ~/Imágenes/Screenshots/'



xfce4-screenshooter -crm
