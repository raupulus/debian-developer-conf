#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style
############################
##      INSTRUCTIONS      ##
############################

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Desktops/i3.sh"
source "$WORKSCRIPT/Desktops/xmonad.sh"
source "$WORKSCRIPT/Desktops/openbox.sh"
source "$WORKSCRIPT/Desktops/gnome-shell.sh"
source "$WORKSCRIPT/Desktops/sway.sh"

############################
##       FUNCIONES        ##
############################
menuDesktops() {
    todos_desktops() {
        clear_screen
        echo -e "$VE Instalando todos los Desktops y WM$CL"
        i3wm_instalador
        xmonad_instalador
        openbox_instalador
        gnome_shell_instalador
        sway_instalador
    }

    if [[ "$1" = '-a' ]]; then
        todos_desktops
    else
        while true :; do
            clear_screen
            local descripcion='Menú de Personalización del sistema
                1) Instalar Sway
                2) Instalar i3wm (x11)
                3) Instalar Xmonad (x11)
                4) Instalar Openbox (x11)
                5) Instalar Gnome Shell
                6) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in
                1)  sway_instalador;;         ## Instala Sway
                2)  i3wm_instalador;;         ## Instala i3wm
                3)  xmonad_instalador;;       ## Instala xmonad
                4)  openbox_instalador;;      ## Instala openbox
                5)  gnome_shell_instalador;;  ## Instala gnome shell
                6)  todos_desktops;;          ## Todos los pasos anteriores

                0)  ## SALIR
                    clear_screen
                    echo -e "$RO Se sale del menú$CL"
                    echo ''
                    break;;

                *)  ## Acción ante entrada no válida
                    echo ""
                    echo -e "             $RO ATENCIÓN: Elección no válida$CL";;
            esac
        done
    fi
}
