#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Apps/IDEs/phpstorm.sh"
source "$WORKSCRIPT/Apps/IDEs/pycharm_pro.sh"
source "$WORKSCRIPT/Apps/IDEs/webstorm.sh"
source "$WORKSCRIPT/Apps/IDEs/netbeans.sh"
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
        phpstorm_instalador
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
                1) PHP Storm
                2) PyCharm Profesional
                3) PyCharm Comunidad (No implementado)
                4) Android Studio (Experimental)
                5) Web Storm
                6) NetBeans (No implementado)
                7) Arduino
                    -------------------
                8) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in
                1)   phpstorm_instalador;;  ##  Instala PHP Storm
                2)   pycharm_pro_instalador;;  ##  Instala Pycharm Profesional
                #3)  ;;  ##
                4)   android_instalador; android_studio_instalador;;  ##
                5)   webstorm_instalador;;  ##
                #6)  ;;  ##
                7)  arduino_instalador;;  ##
                8)  todos_IDES  ## Todos los IDES
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
