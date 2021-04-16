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

    # Listar propiedades
    #gsettings list-recursively org.gnome.shell.keybindings
    #gsettings list-recursively org.gnome.desktop.wm.keybindings

    # Teclas especiales
    # <Control>,<Shift>,<Alt>,<Super>,Right,Left


    ## Toggle pantalla completa
    gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>f']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super><Shift>f']"

    ## Cerrar aplicación
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>q']"

    ## Diálogo para ejecutar
    gsettings set org.gnome.desktop.wm.keybindings panel-run-dialog "['<Alt>F2']"


    ## Mover entre escritorios
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

    ## Cambiar de escritorio
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"

    ##################
    ## Otras configuraciones
    #################

    ## Deshabilitar scroll natural para no invertir mouse
    gsettings set org.gnome.desktop.peripherals.mouse natural-scroll 'false'








    ##################
    ##
    #################
    ## Anulo configuraciones que no necesito
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up  "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-last "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up  "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "[]"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last "[]"
    gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
    gsettings set org.gnome.desktop.wm.keybindings unmaximize "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings  "[]"
    gsettings set org.gnome.desktop.wm.keybindings  "[]"


## Setear
org.gnome.desktop.wm.keybindings minimize ['<Super>comma']

## Anular
org.gnome.desktop.wm.keybindings show-desktop @as []
org.gnome.desktop.wm.keybindings switch-group-backward ['<Shift><Super>Above_Tab', '<Shift><Alt>Above_Tab']


## Anotar
org.gnome.desktop.wm.keybindings begin-resize ['<Alt>F8']
org.gnome.desktop.wm.keybindings begin-move ['<Alt>F7']
org.gnome.desktop.wm.keybindings switch-input-source ['<Super>space', 'XF86Keyboard']
org.gnome.desktop.wm.keybindings activate-window-menu ['<Alt>space']









## Mover a esquina arriba a la izquierda
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-nw "['<Super><Shift>Up']"

## Mover a esquina arriba a la derecha
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-ne "['<Super><Shift>Up']"

## Mover a esquina abajo a la izquierda
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-sw  "['<Super><Shift>Up']"

## Mover a esquina abajo a la derecha
gsettings set org.gnome.desktop.wm.keybindings move-to-corner-se "['<Super><Shift>Up']"


## Pegar al lateral derecho
gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super><Shift>Up']"

## Pegar a la parte de abajo
gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Super><Shift>Up']"

## Mueve al centro de la pantalla
gsettings set org.gnome.desktop.wm.keybindings move-to-center "['<Super><Shift>Up']"

## Pegar al lateral izquierdo
gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super><Shift>Up']"

## Pegar a la parte de arriba
gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Super><Shift>Up']"




## Maximiza la ventana en el eje vertical
gsettings set org.gnome.desktop.wm.keybindings maximize-vertically "['<Super><Shift>Up']"

## Maximiza la ventana en el eje horizontal
gsettings set org.gnome.desktop.wm.keybindings maximize-horizontally "['<Super><Shift>Up']"





gsettings set org.gnome.desktop.wm.keybindings always-on-top "['<Super><Shift>Up']"

gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super><Shift>Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super><Shift>Up']"











org.gnome.desktop.wm.keybindings set-spew-mark @as []
org.gnome.desktop.wm.keybindings switch-windows-backward @as []
org.gnome.desktop.wm.keybindings panel-main-menu ['<Alt>F1']
org.gnome.desktop.wm.keybindings raise-or-lower @as []
org.gnome.desktop.wm.keybindings cycle-windows-backward ['<Shift><Alt>Escape']
org.gnome.desktop.wm.keybindings raise @as []
org.gnome.desktop.wm.keybindings toggle-shaded @as []
org.gnome.desktop.wm.keybindings cycle-group-backward ['<Shift><Alt>F6']
org.gnome.desktop.wm.keybindings cycle-panels-backward ['<Shift><Control><Alt>Escape']
org.gnome.desktop.wm.keybindings switch-applications-backward @as []
org.gnome.desktop.wm.keybindings cycle-group ['<Alt>F6']
org.gnome.desktop.wm.keybindings switch-group ['<Super>Above_Tab', '<Alt>Above_Tab']

org.gnome.desktop.wm.keybindings cycle-panels ['<Control><Alt>Escape']
org.gnome.desktop.wm.keybindings lower @as []
org.gnome.desktop.wm.keybindings toggle-above @as []
org.gnome.desktop.wm.keybindings switch-panels ['<Control><Alt>Tab']
org.gnome.desktop.wm.keybindings cycle-windows ['<Alt>Escape']
















    #/org/gnome/desktop/wm/keybindings/
    #/org/gnome/mutter/keybindings/
    #/org/gnome/mutter/wayland/keybindings/
    #/org/gnome/settings-daemon/plugins/media-keys/

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
