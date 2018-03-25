#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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
##

############################
##     IMPORTACIONES      ##
############################
#source "$WORKSCRIPT/Apps/"

############################
##       FUNCIONES        ##
############################
##
## Menú para elegir los IDE's que vamos a instalar
## @param $1 -a Si recibe este parámetro ejecutará todos los scripts
##
menuIDES() {
    todos_IDES() {
        clear
        echo -e "$VE Instalando todos los IDES$CL"
    }

    ## Si la función recibe "-a" indica que se instalen todos los IDES
    if [[ "$1" = '-a' ]]; then
        todos_IDES
    else
        while true :; do
            clear
            local descripcion='Menú de aplicaciones
                1) Atom
                2) Brackets
                3) PHP Storm
                4) Ninja IDE
                5) NetBeans
                6) Aptana Studio
                7) PyCharm
                8) Web Storm
                9) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  ;;  ##
                2)  ;;  ##
                3)  ;;  ##
                3)  ;;  ##
                3)  ;;  ##
                3)  ;;  ##
                3)  ;;  ##
                3)  ;;  ##
                9)  todos_IDES  ## Todos los IDES
                    break;;

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
