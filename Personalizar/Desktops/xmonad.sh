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

#############################
##     INSTRUCCIONES       ##
#############################


sudo apt-get install xmonad suckless-tools

mkdir ~/.xmonad
vi ~/.xmonad/xmonad.hs


## Añadir archivo de configuración
cp ??? ???

## Compilar
xmonad --recompile


##### CONFIGURACIONES OPCIONALES

## Cambiar background
gconftool --type string --set /desktop/gnome/background/picture_filename "/path/to/your/image.png"

## Cambiar icono gnome reemplazando:
/usr/share/icons/icon-theme/16x16/places/start-here.png
