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

    ## Ver valores posibles de una propiedad
    #gsettings range org.gnome.desktop.wm.preferences visual-bell-type

    # Teclas especiales
    # <Control>,<Shift>,<Alt>,<Super>,Right,Left,Up,Down,Tab

    ## Cantidad de escritorios
    gsettings set org.gnome.desktop.wm.preferences num-workspaces '10'

    ## No mostrar iconos en el escritorio
    gsettings set org.gnome.desktop.background show-desktop-icons 'false'

    ## Calendario
    gsettings set org.gnome.desktop.calendar show-weekdate 'false'
    gsettings set org.gnome.desktop.datetime automatic-timezone 'false'

    ##################
    ## Ventanas y escritorios
    #################

    ## Minimizar al dock
    org.gnome.desktop.wm.keybindings minimize ['<Super>comma']

    ## Bloquear ventana mostrándose siempre encima de las demás
    gsettings set org.gnome.desktop.wm.keybindings always-on-top "['<Super><Shift>U']"

    ## Redimensionar
    org.gnome.desktop.wm.keybindings begin-resize ['<Alt>F8']

    ## Mover
    org.gnome.desktop.wm.keybindings begin-move ['<Alt>F7']

    ## Cambiar fuente de entrad de teclado
    org.gnome.desktop.wm.keybindings switch-input-source ['<Super>space', 'XF86Keyboard']

    ## Abrir menú de la ventana
    org.gnome.desktop.wm.keybindings activate-window-menu ['<Alt>space']

    ## Configuración de mutter
    gsettings set org.gnome.mutter center-new-windows "true"
    gsettings set org.gnome.mutter dynamic-workspaces "false"
    gsettings set org.gnome.mutter edge-tiling "true"
    gsettings set org.gnome.mutter workspaces-only-on-primary "true"

    ## Toggle ventana a pantalla completa y maximizada
    gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>f']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super><Shift>f']"

    ## Cerrar aplicación
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super><Shift>q']"

    ## Diálogo para ejecutar
    gsettings set org.gnome.desktop.wm.keybindings panel-run-dialog "['<Alt>F2']"

    ## Switch entre aplicaciones abiertas
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"

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

    ## Mueve la ventana a media pantalla ocupando todo el alto
    gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Shift><Super>Right']"
    gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Shift><Super>Left']"

    ## Maximiza la ventana en el eje vertical
    gsettings set org.gnome.desktop.wm.keybindings maximize-vertically "['<Super><Shift>Up']"

    ## Maximiza la ventana en el eje horizontal
    gsettings set org.gnome.desktop.wm.keybindings maximize-horizontally "['<Super><Shift>Down']"

    ## Pegar a la parte de arriba
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Super><Control>Up']"

    ## Pegar al lateral derecho
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super><Control>Right']"

    ## Pegar a la parte de abajo
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Super><Control>Down']"

    ## Pegar al lateral izquierdo
    gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super><Control>Left']"

    ## Mueve al centro de la pantalla
    gsettings set org.gnome.desktop.wm.keybindings move-to-center "['<Super><Control>Space']"

    ## Mover a esquina arriba a la izquierda
    gsettings set org.gnome.desktop.wm.keybindings move-to-corner-nw "['<Super><Shift>UpLeft']"

    ## Mover a esquina arriba a la derecha
    gsettings set org.gnome.desktop.wm.keybindings move-to-corner-ne "['<Super><Shift>Up']"

    ## Mover a esquina abajo a la izquierda
    gsettings set org.gnome.desktop.wm.keybindings move-to-corner-sw  "['<Super><Shift>Up']"

    ## Mover a esquina abajo a la derecha
    gsettings set org.gnome.desktop.wm.keybindings move-to-corner-se "['<Super><Shift>Up']"

    ##################
    ## Anulo configuraciones que no necesito
    #################
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[]"
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
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "[]"
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-panels "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-windows "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-panels "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-windows-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-panels-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-group-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings cycle-group "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-group "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "[]"
    gsettings set org.gnome.desktop.wm.keybindings toggle-above "[]"
    gsettings set org.gnome.mutter.keybindings tab-popup-cancel "[]"
    gsettings set org.gnome.mutter.keybindings tab-popup-select "[]"
    gsettings set org.gnome.mutter.keybindings rotate-monitor "[]"
    gsettings set org.gnome.mutter.keybindings switch-monitor "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-1 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-2 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-3 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-4 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-5 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-6 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-7 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-8 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-9 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-10 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-11 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings switch-to-session-12 "[]"
    gsettings set org.gnome.mutter.wayland.keybindings restore-shortcuts "[]"
    gsettings set org.gnome.desktop.wm.keybindings  "[]"
    gsettings set org.gnome.desktop.wm.keybindings  "[]"
    gsettings set org.gnome.desktop.wm.keybindings  "[]"
    gsettings set org.gnome.desktop.wm.keybindings  "[]"
    gsettings set org.gnome.desktop.wm.keybindings  "[]"
    gsettings set org.gnome.desktop.wm.keybindings set-spew-mark "[]"
    gsettings set org.gnome.desktop.wm.keybindings raise-or-lower "[]"
    gsettings set org.gnome.desktop.wm.keybindings raise "[]"
    gsettings set org.gnome.desktop.wm.keybindings toggle-shaded "[]"
    gsettings set org.gnome.desktop.wm.keybindings lower "[]"
    gsettings set org.gnome.shell.keybindings focus-active-notification "[]"
    gsettings set org.gnome.shell.keybindings open-application-menu "[]"
    gsettings set org.gnome.shell.keybindings toggle-message-tray "[]"
    gsettings set org.gnome.shell.keybindings toggle-application-view "[]"
    gsettings set org.gnome.shell.keybindings toggle-overview "[]"
    gsettings set org.gnome.shell.keybindings shift-overview-up "[]"
    gsettings set org.gnome.shell.keybindings shift-overview-down "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
    gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"


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
