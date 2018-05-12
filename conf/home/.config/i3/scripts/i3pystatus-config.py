# -*- coding: utf-8 -*-

import subprocess
import os.path as path

from i3pystatus import Status
from i3pystatus.updates import aptget


status = Status()

## Variables para colores
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
    text = "",
    ## Abrir el menu obmenubar
    on_leftclick = "~/mimenu/obmenubar",
    ## Abrir terminal
    on_rightclick = "tilix",
    )



## Actuaklizaciones ----------------------------------------------------
status.register("updates",
   format = ":{count}",
    format_no_updates = "",
    on_leftclick="tilix -e 'sudo apt upgrade -y'",
    color=updatesFColor,
    backends = [aptget.AptGet()],
    )

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week

## Reloj ---------------------------------------------------------------
status.register("clock",
    hints= {"markup": "pango"},
    format="<span background='"+alsaColor+"' color ='#002B36'></span>"+"  %H:%M",
    color=clockFColor,
    interval=5,
    on_leftclick="zenity --calendar --text ''",)

## CAL -----------------------------------------------------------------
#status.register("clock",
    #format="  %a %d-%m-%Y ",
    #color='#61AEEE',
    #interval=1,)

## ALSA SOUND ----------------------------------------------------------
status.register("alsa",
    #on_leftclick = "switch_mute",
    on_leftclick = "amixer -D pulse set Master toggle",
    # or as a strings without the list
    #on_upscroll = "increase_volume",
    #on_downscroll = "decrease_volume",
    # this will refresh any module by clicking on it
    on_rightclick = "pavucontrol",
    color=alsaFColor,
    color_muted  = '#E06C75',
    #format_muted=' [muted]',
    #format=" {volume}%",
    hints= {"markup": "pango","separator": False,"separator_block_width": 0},
    format = "<span background='"+backlightColor+"' color='"+alsaColor+"'></span\
             ><span background='"+alsaColor+"' > {volume}% </span>",

    format_muted = "<span background='"+backlightColor+"' color='"+alsaColor+"'></span\
             ><span background='"+alsaColor+"' > [muted] </span>",


    )

## BACKLIGHT -----------------------------------------------------------
## Solo se carga si existe
if path.exists('/sys/class/backlight/intel_backlight'):
    status.register("backlight",
        interval=5,
        color = backlightFColor,
        #format=" {percentage:.0f}%",
         hints= {"markup": "pango","separator": False,"separator_block_width": 0},
        format = "<span background='"+networkColor+"' color='"+backlightColor+"'></span\
                 ><span background='"+backlightColor+"'> {percentage:.0f}% </span>",
        backlight="intel_backlight",
        )

## WIRELESS ------------------------------------------------------------
status.register("network",
    interface="wlp3s0",

     color_up = networkFColor,
    color_down=networkFColor,
     hints= {"markup": "pango","separator": False,"separator_block_width": 0},
    #format_up=" {essid}  {bytes_recv:6.1f}KiB",

    format_up = "<span background='"+batteryColor+"' color='"+networkColor+"'></span\
        ><span background='"+networkColor+"' >{essid} {bytes_recv:6.1f}KiB {bytes_sent:5.1f}KiB</span>",

	 format_down = "<span background='"+batteryColor+"' color='"+networkColor+"'></span\
        ><span background='"+networkColor+"' ></span>",

    )

## BATERIA -------------------------------------------------------------
## Solo carga si hay una batería
if path.exists('/sys/class/power_supply/BAT0'):
   status.register("battery",
       #battery_ident="BAT1",
       interval=3,
       #format="{status} {percentage:.0f}%",
       hints= {"markup": "pango","separator": False,"separator_block_width": 0},
       format    = "<span background='"+tempColor+"' color='"+batteryColor+"'></span\
                    ><span background='"+batteryColor+"'> {status} {percentage:.0f}%</span>",

       alert=True,
       alert_percentage=30,
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

## TEMPERATURA ---------------------------------------------------------
status.register("temp",
	hints= {"markup": "pango","separator": False,"separator_block_width": 0},
     #format = " {temp}°",
    format    = "<span background='"+cpuColor+"' color='"+tempColor+"'></span\
                 ><span background='"+tempColor+"'>  {temp}°</span>",
    color=tempFColor,
    alert_color = "#FFEF00",
    alert_temp = 60,
  )

## CPU USO -------------------------------------------------------------
status.register("cpu_usage",
	color=cpuFColor,
	hints= {"markup": "pango","separator": False,"separator_block_width": 0},
	on_leftclick="tilix --title=htop -e 'htop'",

    format = "<span background='"+memColor+"' color='"+cpuColor+"'></span\
                 ><span background='"+cpuColor+"' >  {usage}%</span>",



    )

## MEMORIA -------------------------------------------------------------
status.register("mem",
	hints= {"markup": "pango","separator": False,"separator_block_width": 0},
    color=memFColor,
    warn_color="#E5E500S",
    alert_color="#FF1919",
     #format=" {percent_used_mem}",

      format    = "<span background='"+diskColor+"' color='"+memColor+"'></span\
                 ><span background='"+memColor+"' > {percent_used_mem}%</span>",
    #divisor=1073741824,
    )

## DISK USAGE ----------------------------------------------------------
status.register("disk",
    hints= {"markup": "pango","separator": False,"separator_block_width": 0},
    color=diskFColor,
    path="/",
    on_leftclick="thunar",
    #format=" {avail} GB",

      format = "<span color='"+diskColor+"'></span\
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

status.run()
