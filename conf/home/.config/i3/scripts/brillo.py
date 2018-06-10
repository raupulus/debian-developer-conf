#!/usr/bin/python3
# -*- encoding: utf-8 -*-

# @author     Raúl Caro Pastorino
# @email      tecnico@fryntiz.es
# @web        http://www.fryntiz.es
# @github     https://github.com/fryntiz
# @gitlab     https://gitlab.com/fryntiz
# @twitter    https://twitter.com/fryntiz

# Create Date: 11/06/2018
# Project Name: Brillo para intel_backlight
# Description: Permite aumentar o disminuir el brillo en portátiles soportados.
#
# Dependencies:
#
# Revision 0.01 - File Created
# Additional Comments:

# @copyright  Copyright © 2018 Raúl Caro Pastorino
# @license    https://wwww.gnu.org/licenses/gpl.txt

# Copyright (C) 2018  Raúl Caro Pastorino
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

# Guía de estilos aplicada: PEP8

#######################################
# #       Importar Librerías        # #
#######################################
#import os
import sys

#######################################
# #             Variables           # #
#######################################
dispositivo = '/sys/class/backlight/intel_backlight/brightness'
max_brightness = open('/sys/class/backlight/intel_backlight/max_brightness','r').read()
brightness = open(dispositivo,'r').read()
n_parametros = len(sys.argv)
parametros = sys.argv  # El primer parámetro (0) es el nombre del script
diferencia = 600  # Valor en el que aumenta o disminuye el brillo

#######################################
# #             Funciones           # #
#######################################
def newBrightness(value):
    """
    Establece el valor pasado como parámetro al dispositivo de brillo.
    """
    f = open (dispositivo,'w')
    f.write(str(value))
    f.close()

def nextValue():
    """
    Elige el próximo valor para establecer el brillo.
    """
    value = int(brightness) + diferencia
    if (value >= 4437):
        newBrightness('4437')
    else:
        newBrightness(value)

def backValue():
    """
    Elige el valor más bajo que sigue para establecer el brillo.
    """
    value = int(brightness) - diferencia
    if (value <= 0):
        newBrightness('100')
    else:
        newBrightness(value)

if (parametros[1] in 'next n + ++'):
    nextValue()
elif (parametros[1] in 'back b - --'):
    backValue()
