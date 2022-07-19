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
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Este script enlaza la instalación de todas las aplicaciones opcionales
## que podían ser interesante instalar en uno u otro momento.

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Apps/DBeaver.sh"
source "$WORKSCRIPT/Apps/GitKraken.sh"
source "$WORKSCRIPT/Apps/Haroopad.sh"
source "$WORKSCRIPT/Apps/Pencil-Project.sh"
source "$WORKSCRIPT/Apps/Geany.sh"
source "$WORKSCRIPT/Apps/Firefox.sh"

############################
##       FUNCIONES        ##
############################

instalar_todas_aplicaciones_extras() {
    dbeaver_instalador
    gitkraken_instalador
    haroopad_instalador
    pencilProject_instalador
    firefox_instalador
    geany_Instalador
}

aplicaciones_extras() {
    echo -e "$VE Instalando Aplicaciones$RO Extras$CL"
    if [[ "$1" = '-a' ]]; then
        instalar_todas_aplicaciones_extras
    else
        while true :; do
            clear_screen
            local descripcion='Menú de aplicaciones
                1) DBeaver
                2) GitKraken
                3) Haroopad
                4) pencilProject
                5) Firefox
                6) Geany
                7) Todos los pasos anteriores completos

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  dbeaver_install;;
                2)  gitkraken_instalador;;
                3)  haroopad_instalador;;
                4)  pencilProject_instalador;;
                5)  firefox_instalador;;
                6)  geany_Instalador;;
                7)  instalar_todas_aplicaciones_extras; break;;

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
