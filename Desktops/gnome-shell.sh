#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Plantea la instalación de gnome_shell con las configuraciones

############################
##       FUNCIONES        ##
############################
gnome_shell_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Gnome Shell$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/wayland-base.lst"
    instalarSoftwareLista "$SOFTLIST/Desktops/x11-base.lst"
}

gnome_shell_instalar() {
    echo -e "$VE Preparando para instalar$RO Gnome Shell$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/gnome.lst"
}

##
## Instalando software extra y configuraciones adicionales
##
gnome_shell_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Gnome Shell$CL"

    echo -e "$VE Instalando software secundario$CL"
    instalarSoftwareLista "$SOFTLIST/Desktops/gnome-extensions.lst"

    echo -e "$VE Generando archivos de configuración$CL"
    enlazarHome '.config/geany' '.config/gtk-2.0' '.config/gtk-3.0' '.config/gtk-4.0'
}

gnome_shell_postconfiguracionOpcional() {
    echo -e "$VE Generando Post-Configuraciones Opcionales$RO Gnome Shell$CL"

    ## TODO → agregar atajos de teclado.
    ## TODO → Agregar extensiones a la lista y añadir sus configuraciones.
    ## TODO → Setear tema personalizado.
}

gnome_shell_instalador() {
    echo -e "$VE Comenzando instalación de$RO Gnome Shell$CL"

    gnome_shell_preconfiguracion
    gnome_shell_instalar
    gnome_shell_postconfiguracion
    gnome_shell_postconfiguracionOpcional
}
