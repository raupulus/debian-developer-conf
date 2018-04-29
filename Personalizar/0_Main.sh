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

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Personalizar/Configurar_GIT.sh"
source "$WORKSCRIPT/Personalizar/Personalizar_GTK.sh"
source "$WORKSCRIPT/Personalizar/Tipografias.sh"
source "$WORKSCRIPT/Personalizar/Variables_Entorno.sh"

###########################
##       FUNCIONES       ##
###########################
menuPersonalizacion() {
    todas_personalizaciones() {
        clear
        echo -e "$VE Instalando todas las personalizaciones$CL"
        configuracion_git
        personalizarGTK
        agregar_fuentes
        instalar_variables
    }

    ## Si la función recibe "-a" indica que instale todos los servidores
    if [[ "$1" = '-a' ]]; then
        todas_personalizaciones
    else
        while true :; do
            clear
            local descripcion='Menú de Personalización del sistema
                1) Configurar GIT
                2) Personalizar GTK
                3) Tipografías
                4) Variables de Entorno
                5) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  configuracion_git;;        ## Configurar GIT
                2)  personalizarGTK;;          ## Personalizar GTK
                3)  agregar_fuentes;;          ## Tipografías
                4)  instalar_variables;;       ## Variables de Entorno
                5)  todas_personalizaciones;;  ## Todos los pasos anteriores

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
