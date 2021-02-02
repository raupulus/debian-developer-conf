#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################
##

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Apps/IDEs/Atom_IDE.sh"
source "$WORKSCRIPT/Apps/IDEs/Brackets.sh"
source "$WORKSCRIPT/Apps/IDEs/Ninja-IDE.sh"
source "$WORKSCRIPT/Apps/IDEs/phpstorm.sh"
source "$WORKSCRIPT/Apps/IDEs/pycharm_pro.sh"
source "$WORKSCRIPT/Apps/IDEs/webstorm.sh"
source "$WORKSCRIPT/Apps/IDEs/netbeans.sh"
source "$WORKSCRIPT/Apps/IDEs/aptanastudio.sh"
source "$WORKSCRIPT/Apps/IDEs/Arduino.sh"
source "$WORKSCRIPT/Apps/IDEs/android_studio.sh"

############################
##       FUNCIONES        ##
############################
##
## Menú para elegir los IDE's que vamos a instalar
## @param $1 -a Si recibe este parámetro ejecutará todos los scripts
##
menuIDES() {
    todos_IDES() {
        clear_screen
        echo -e "$VE Instalando todos los IDES$CL"
        atom_instalador
        brackets_instalador
        phpstorm_instalador
        ninjaide_instalador
        pycharm_pro_instalador
        android_studio
    }

    ## Si la función recibe "-a" indica que se instalen todos los IDES
    if [[ "$1" = '-a' ]]; then
        todos_IDES
    else
        while true :; do
            clear_screen
            local descripcion='Menú de aplicaciones
                1) Atom
                2) Brackets
                3) PHP Storm
                4) PyCharm Profesional
                5) PyCharm Comunidad (No implementado)
                6) Ninja IDE
                7) NetBeans (No implementado)
                8) Android Studio (Experimental)
                9) Web Storm
                10) Arduino
                11) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)   atom_instalador;;      ##  Instala Atom
                2)   brackets_instalador;;  ##  Instala Brackets
                3)   phpstorm_instalador;;  ##  Instala PHP Storm
                4)   pycharm_pro_instalador;;  ##  Instala Pycharm Profesional
                #5)  ;;  ##
                6)   ninjaide_instalador;;  ##  Instala Ninja IDE
                8)   android_instalador; android_studio_instalador;;  ##
                9)   webstorm_instalador;;  ##
                10)  arduino_instalador;;  ##
                11)  todos_IDES  ## Todos los IDES
                     break;;

                0)  ## SALIR
                    clear_screen
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
