#!/usr/bin/python3
# -*- encoding: utf-8 -*-

# @author     Raúl Caro Pastorino
# @copyright  Copyright © 2018 Raúl Caro Pastorino
# @license    https://wwww.gnu.org/licenses/gpl.txt
# @email      tecnico@fryntiz.es
# @web        www.fryntiz.es
# @github     https://github.com/fryntiz
# @gitlab     https://gitlab.com/fryntiz
# @twitter    https://twitter.com/fryntiz

# Guía de estilos aplicada: PEP8

#######################################
# #           Descripción           # #
#######################################

#######################################
# #       Importar Librerías        # #
#######################################
import subprocess
import os.path as path

from i3pystatus import Status
from i3pystatus.updates import aptget

from time import sleep
from os import listdir
import re

#######################################
# #             Variables           # #
#######################################
status = Status()

## Todas las interfaces de red
interfaces = " ".join(listdir('/sys/class/net/'))

patron_wlan = re.compile(r'w\w+')
patron_eth = re.compile(r'e\w+')

## Lista con cada tipo de interfaz de red
wlan = patron_wlan.findall(str(interfaces))
ethernet = patron_eth.findall(str(interfaces))

## Variables para colores
naranja = ''
amarillo = '#ffff33'
azul = '#3300ff'
gris = ''
pastel = ''
negro = ''
naranja = ''
verde = '#00cc00'
verdeC = '#99ff66'
rojo = '#cc0000'
rojoC = ''
rosa = ''
marron = ''
background = ''
backgroundC = ''

#######################################
# #             Funciones           # #
#######################################
updatesFColor='#CA4932'
clockFColor='#E6E6FA'
forColor='#EDE4E4'

alsaColor='#D22D72'
alsaFColor='#D5AEBE'

backlightColor='#568C3B'
backlightFColor='#AAF3AA'

networkColor='#48417C'
networkFColor='#68C274'

batteryColor='#257FAD'
batteryFColor='#D0C6A6'

tempColor='#EF3E14'
tempFColor='#E4DCDA'

cpuColor='#5D5DB1'
cpuFColor='#C4C4E0'

memColor='#BF6643'
memFColor='#DACAC4'

diskColor='#5A7B8C'
diskFColor='#C4D5DD'

## Menu ----------------------------------------------------------------
status.register("text",
    text = "Debian ",
    ## Abrir el menu obmenubar
    on_leftclick = "~/.config/i3/scripts/menu",
    ## Abrir terminal
    #on_rightclick = "tilix",
)

## Grabación
status.register("text",
    text = "\uf03dGrabar",
    ## Abrir el menu obmenubar
    on_leftclick = "~/.config/i3/scripts/record.sh start",
    ## Abrir terminal
    on_rightclick = "~/.config/i3/scripts/record.sh stop",
)

## Actualizaciones -----------------------------------------------------
status.register("updates",
    format = "APT:{count}",
    format_no_updates = "OK",
    on_leftclick = "sudo apt update -y",
    on_rightclick = "sudo apt upgrade -y",
    color = updatesFColor,
    backends = [aptget.AptGet()],
)

## BACKLIGHT -----------------------------------------------------------
## Solo se carga si existe
if path.exists('/sys/class/backlight/intel_backlight'):
    status.register("backlight",
        interval=5,
        color = backlightFColor,
        format=" {percentage:.0f}%",
        hints= {"markup": "pango","separator": True,"separator_block_width": 12},
        #hints= {"markup": "pango","separator": False,"separator_block_width": 0},
        #format = "<span background='"+networkColor+"' color='"+backlightColor+"'></span\
        #><span background='"+backlightColor+"'> {percentage:.0f}% </span>",
        backlight="intel_backlight",
        )

## BATERIA -------------------------------------------------------------
## Solo carga si hay una batería
if path.exists('/sys/class/power_supply/BAT0'):
    status.register("battery",
        #battery_ident="BAT1",
        interval=3,
        format="{status} {percentage:.0f}%",
        hints= {"markup": "pango","separator": True,"separator_block_width": 12},
        #hints= {"markup": "pango","separator": False,"separator_block_width": 0},
        #format    = "<span background='"+tempColor+"' color='"+batteryColor+"'></span\
        #><span background='"+batteryColor+"'> {status} {percentage:.0f}%</span>",

        alert=True,
        alert_percentage=10,
        color=forColor,
        critical_color="#FF1919",
        charging_color="#E5E500",
        full_color=batteryFColor,
        status={
            "DIS": " ",
            "CHR": "  ",
            "FULL": " ",
        },
    )

## Reloj ---------------------------------------------------------------
# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
    hints= {"markup": "pango"},
    format="<span background='"+alsaColor+"' color ='#002B36'></span>"+"  %H:%M",
    color=verdeC, #clockFColor,
    interval=5,
    on_leftclick="zenity --calendar --text ''",)

## CAL -----------------------------------------------------------------
#status.register("clock",
#    format = "  %a %d-%m-%Y",
#    color = verdeC,
#    interval = 1,
#)

## REPRODUCTOR -------------------------------------------------------------
#status.register(
#    "cmus",
#    #format = "[{status}{artist: >.50} - {title: >.50}]",
#    format = "<span background='"+backlightColor+"' color='"+alsaColor+"'></span\
#             ><span background='"+alsaColor+"' >{status}{artist: >.50} - {title: >.50}</span>",
#    status = {'stop': '', 'play': '', 'pause': ''},
#)

## ALSA SOUND ----------------------------------------------------------
status.register("alsa",
    on_leftclick = "amixer set Master toggle",
    #on_upscroll = "amixer set Master 10%+",
    #on_downscroll = "amixer set Master 10%-",
    on_rightclick = "pavucontrol",
    color = alsaFColor,
    color_muted = '#E06C75',
    #format_muted=' [muted]',
    #format=" {volume}%",
    hints= {"markup": "pango","separator": False,"separator_block_width": 0},
    format = "<span background='"+tempColor+"' color='"+alsaColor+"'></span\
             ><span background='"+alsaColor+"' > {volume}% </span>",

    format_muted = "<span background='"+tempColor+"' color='"+alsaColor+"'></span\
             ><span background='"+alsaColor+"' > [muted] </span>",
    )

## TEMPERATURA ---------------------------------------------------------
status.register("temp",
    hints = {"markup": "pango","separator": False,"separator_block_width": 0},
     #format = " {temp}°",
    format = "<span background='"+cpuColor+"' color='"+tempColor+"'></span\
             ><span background='"+tempColor+"'>  {temp}°C</span>",
    color = tempFColor,
    alert_color = "#FFEF00",
    alert_temp = 60,
  )

## CPU USO -------------------------------------------------------------
status.register("cpu_usage",
    color=cpuFColor,
    hints= {"markup": "pango","separator": False,"separator_block_width": 0},
    on_leftclick="tilix --title=htop -e 'htop'",

    format = "<span background='"+memColor+"' color='"+cpuColor+"'></span\
             ><span background='"+cpuColor+"' > CPU {usage}%</span>",
    )

## MEMORIA -------------------------------------------------------------
status.register("mem",
    hints = {"markup": "pango","separator": False,"separator_block_width": 0},
    color = memFColor,
    warn_color = "#E5E500S",
    alert_color = "#FF1919",
    #format = " {percent_used_mem}",

    format = "<span background='"+diskColor+"' color='"+memColor+"'></span\
             ><span background='"+memColor+"' > RAM {percent_used_mem}%</span>",
    #divisor = 1073741824,
    )

## DISK USAGE ----------------------------------------------------------
status.register("disk",
    hints = {"markup": "pango","separator": False,"separator_block_width": 0},
    color = diskFColor,
    path = "/",
    on_leftclick = "thunar",
    #format=" {avail} GB",

    format = "<span background='"+networkColor+"' color='"+diskColor+"'></span\
             ><span background='"+diskColor+"' > {avail} GB</span>",
)

#status.register('ping',
#    format_disabled='',
#    color='#61AEEE')

#status.register("keyboard_locks",
    #format='{caps} {num}',
    #caps_on='Caps Lock',
    #caps_off='',
    #num_on='',
    #num_off='',
    #color='#FFC0CB',
    #)



#status.register("xkblayout",
    #layouts=["fr", "ar"],
    #format = u"\u2328 {name}",
    #)

## WIRELESS ------------------------------------------------------------
## Por cada interfaz de red wireless genero un monitor de estado
for ifc in wlan:
    status.register("network",
        interface=ifc,

        color_up = networkFColor,
        color_down = networkFColor,
        hints = {"markup": "pango","separator": False,"separator_block_width": 0},
        #format_up=" {essid}  {bytes_recv:6.1f}KiB",

        #format_up = "<span background='"+batteryColor+"' color='"+networkColor+"'></span\
        #><span background='"+networkColor+"' >{essid} {bytes_recv:6.1f}KiB {bytes_sent:5.1f}KiB</span>",

        format_up = "<span background='"+networkColor+"' color='"+networkColor+"'></span\
        ><span background='"+networkColor+"' > {bytes_recv:6.1f}K {bytes_sent:5.1f}K</span>",

        format_down = "<span background='"+networkColor+"' color='"+networkColor+"'></span\
        ><span background='"+networkColor+"' ></span>",
    )

## ETHERNET ------------------------------------------------------------
## Por cada interfaz de red wireless genero un monitor de estado
for ifc in ethernet:
    status.register(
        "network",
        interface = ifc,

        color_up = networkFColor,
        color_down=networkFColor,
        hints= {"markup": "pango","separator": False,"separator_block_width": 0},

        format_up = "<span color='"+networkColor+"'>\uE0B2</span\
        ><span background='"+networkColor+"' >\uE0A0 {bytes_recv:6.1f}K {bytes_sent:5.1f}K</span>",

        format_down = "",
    )

status.run()
