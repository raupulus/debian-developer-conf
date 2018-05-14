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
source "$WORKSCRIPT/Personalizar/Personalizacion_GTK.sh"
source "$WORKSCRIPT/Personalizar/Tipografias.sh"
source "$WORKSCRIPT/Personalizar/iconos.sh"
source "$WORKSCRIPT/Personalizar/Variables_Entorno.sh"
source "$WORKSCRIPT/Personalizar/Terminales.sh"
source "$WORKSCRIPT/Personalizar/Desktops/0_Main.sh"

############################
##       FUNCIONES        ##
############################
menuPersonalizacion() {
    todas_personalizaciones() {
        clear
        echo -e "$VE Instalando todas las personalizaciones$CL"
        configuracion_git
        agregar_fuentes
        instalar_variables
        instalar_iconos
        personalizarGTK
        terminales_instalador
    }

    ## Si la función recibe "-a" indica que instale todas
    if [[ "$1" = '-a' ]]; then
        todas_personalizaciones
    else
        while true :; do
            clear
            local descripcion='Menú de Personalización del sistema
                1) Configurar GIT
                2) Tipografías
                3) Variables de Entorno
                4) Instalar Iconos
                5) Personalizar GTK
                6) Configurar Terminales (Tilix y Terminator)
                7) Todos los pasos anteriores
                8) Instalar un Desktop o Window Manager

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  configuracion_git;;        ## Configurar GIT
                2)  agregar_fuentes;;          ## Tipografías
                3)  instalar_variables;;       ## Variables de Entorno
                4)  instalar_iconos;;          ## Iconos Personalizados
                5)  personalizarGTK;;          ## Personalizar GTK
                6)  terminales_instalador;;    ## Configura terminales
                7)  todas_personalizaciones;;  ## Todos los pasos anteriores
                8)  menuDesktops;;             ## Lleva al menú Escritorios

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
