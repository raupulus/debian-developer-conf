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
source "$WORKSCRIPT/Personalizar/Desktops/i3.sh"
source "$WORKSCRIPT/Personalizar/Desktops/xmonad.sh"

###########################
##       FUNCIONES       ##
###########################
menuDesktops() {
    todos_desktops() {
        clear
        echo -e "$VE Instalando todos los Desktops y WM$CL"
        i3wm_instalador
        xmonad_instalador
    }

    ## Si la función recibe "-a" indica que instale todas las opciones
    if [[ "$1" = '-a' ]]; then
        todos_desktops
    else
        while true :; do
            clear
            local descripcion='Menú de Personalización del sistema
                1) Instalar i3wm
                2) Instalar xmonad
                3) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in
                1)  i3wm_instalador;;        ## Instala i3wm
                2)  xmonad_instalador;;      ## Instala xmonad
                3)  todos_desktops;;         ## Todos los pasos anteriores

                0)  ## SALIR
                    clear
                    echo -e "$RO Se sale del menú$CL"
                    echo ''
                    break;;

                *)  ## Acción ante entrada no válida
                    echo ""
                    echo -e "                      $RO ATENCIÓN: Elección no válida$CL";;
            esac
        done
    fi
}
