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
############################
##     INSTRUCCIONES      ##
############################

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Desktops/i3.sh"
source "$WORKSCRIPT/Desktops/xmonad.sh"
source "$WORKSCRIPT/Desktops/openbox.sh"
source "$WORKSCRIPT/Desktops/gnome-shell.sh"

############################
##       FUNCIONES        ##
############################
menuDesktops() {
    todos_desktops() {
        clear
        echo -e "$VE Instalando todos los Desktops y WM$CL"
        i3wm_instalador
        xmonad_instalador
        openbox_instalador
        gnome_shell_instalador
    }

    if [[ "$1" = '-a' ]]; then
        todos_desktops
    else
        while true :; do
            clear
            local descripcion='Menú de Personalización del sistema
                1) Instalar i3wm
                2) Instalar Xmonad
                3) Instalar Openbox
                4) Instalar Gnome Shell
                5) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in
                1)  i3wm_instalador;;         ## Instala i3wm
                2)  xmonad_instalador;;       ## Instala xmonad
                3)  openbox_instalador;;      ## Instala openbox
                4)  gnome_shell_instalador;;  ## Instala gnome shell
                5)  todos_desktops;;          ## Todos los pasos anteriores

                0)  ## SALIR
                    clear
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
