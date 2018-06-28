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

###########################
##       FUNCIONES       ##
###########################
##
## Menú para elegir el conjunto de paquetes a instalar
## @param $1 -a Si recibe este parámetro ejecutará todos los scripts
##
menuPaquetes() {
    todos_paquetes() {
        clear
        echo -e "$VE Instalando todos los paquetes$CL"

        instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/developer.lst"
        instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/diseño-grafico.lst"
        instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/edicion-multimedia.lst"
        instalarSoftwareFlatPakLista "$WORKSCRIPT/Apps/Packages/flatpak.lst"
        instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/internet.lst"
        instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/x11-base.lst"
        instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/vps.lst"
    }

    ## Si la función recibe "-a" indica que instale todos los paquetes
    if [[ "$1" = '-a' ]]; then
        todos_paquetes
    else
        while true :; do
            clear
            local descripcion='Menú de Servidores y Lenguajes de programación
                1) Developer
                2) Diseño Gráfico
                3) Edición Multimedia
                4) Flatpak
                5) Internet
                6) X11 base (xorg xorg-server...)
                7) Todos los pasos anteriores

                8) VPS

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/developer.lst";;
                2)  instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/diseño-grafico.lst";;
                3)  instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/edicion-multimedia.lst";;
                4)  instalarSoftwareFlatPakLista "$WORKSCRIPT/Apps/Packages/flatpak.lst";;
                5)  instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/internet.lst";;
                6)  instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/x11-base.lst";;
                7)  todos_paquetes
                    break;;
                8)  instalarSoftwareLista "$WORKSCRIPT/Apps/Packages/vps.lst";;

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
