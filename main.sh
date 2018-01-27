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
## Script principal
## Desde aquí se llamaran a todos los demás scripts separando
## funciones para cada uno de ellos.
##
## Ten en cuenta que este script hace modificaciones en el equipo a mi gusto
## Puede no funcionar correctamente si usas software de repositorios externo
## Probablemente no funcionará en otras distribuciones distintas
## a Debian rama Stable.

############################
##       CONSTANTES       ##
############################
AM="\033[1;33m"  ## Color Amarillo
AZ="\033[1;34m"  ## Color Azul
BL="\033[1;37m"  ## Color Blanco
CY="\033[1;36m"  ## Color Cyan
GR="\033[0;37m"  ## Color Gris
MA="\033[1;35m"  ## Color Magenta
RO="\033[1;31m"  ## Color Rojo
VE="\033[1;32m"  ## Color Verde
CL="\e[0m"       ## Limpiar colores

WORKSCRIPT=$PWD  ## Directorio principal del script
USER=$(whoami)   ## Usuario que ejecuta el script
VERSION='0.4.1'  ## Versión en desarrollo

############################
##     IMPORTACIONES      ##
############################
<<<<<<< HEAD
source "$WORKSCRIPT/Agregar_Repositorios.sh"
source "$WORKSCRIPT/funciones.sh"
source "$WORKSCRIPT/Apps/0_Main.sh"
#source 'conf/0_Main.sh'
#source 'servers/0_Main.sh'
#source 'Personalizar/0_Main.sh'
#source ./Tipografías.sh
#source ./Instalar_Configuraciones.sh
#source ./Variables_Entorno.sh
#source ./Configurar_GIT.sh
#source ./Personalización_GTK.sh
#source ./Servidores.sh
#source ./limpiador.sh
=======
source "$WORKSCRIPT/funciones.sh"
source "$WORKSCRIPT/Agregar_Repositorios.sh"
source "$WORKSCRIPT/Instalar_Configuraciones.sh"
source "$WORKSCRIPT/limpiador.sh"
source "$WORKSCRIPT/Servidores.sh"

source "$WORKSCRIPT/Apps/0_Main.sh"
#source 'servers/0_Main.sh'
#source 'Personalizar/0_Main.sh'

>>>>>>> de276599169a9e59f4d1adf0546b5bcb24705ab4

###########################
##       VARIABLES       ##
###########################
errores=()

###########################
##       FUNCIONES       ##
###########################
menuPrincipal() {
    while true :; do
        clear

        local descripcion='Menú Principal
            1) Agregar Repositorios
            2) Aplicaciones
            3) Configuraciones
            4) Personalización
            5) Servidores
            6) Todos los pasos anteriores a la vez

            0) Salir
        '
        opciones "$descripcion"

        echo -e "$RO"
        read -p "    Acción → " entrada
        echo -e "$CL"

        case $entrada in

<<<<<<< HEAD
            1) agregar_repositorios;; ## Menú de Repositorios
            2) menuAplicaciones;;     ## Menú de Aplicaciones
            3) menuConfiguraciones;;  ## Menú de Configuraciones
            4) menuPersonalizacion;;  ## Menú de Personalización
            5) menuServidores;;       ## Menú de Servidores
            6) echo "";;              ## Todos los pasos anteriores
=======
            1) agregar_repositorios;;  ## Menú de Repositorios
            2) menuAplicaciones;;      ## Menú de Aplicaciones
            3) menuConfiguraciones;;   ## Menú de Configuraciones
            4) menuPersonalizacion;;   ## Menú de Personalización
            5) menuServidores;;        ## Menú de Servidores
            6) echo "";;               ## Todos los pasos anteriores
>>>>>>> de276599169a9e59f4d1adf0546b5bcb24705ab4

            0)  ## SALIR
                clear
                echo -e "$RO Se sale del menú$CL"
                echo ''
                exit 0;;

            *)  ## Acción ante entrada no válida
                clear
                echo ""
                echo -e "                      $RO ATENCIÓN: Elección no válida$CL";;
        esac
    done
}

###########################
##       EJECUCIÓN       ##
###########################
menuPrincipal
