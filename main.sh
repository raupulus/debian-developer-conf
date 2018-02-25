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
VERSION='0.5.3'  ## Versión en desarrollo
LOGERROR="$WORKSCRIPT/errores.log"  ## Archivo donde almacenar errores
DEBUG=false      ## Establece si está el script en modo depuración

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Agregar_Repositorios.sh"
source "$WORKSCRIPT/funciones.sh"
source "$WORKSCRIPT/Instalar_Configuraciones.sh"
source "$WORKSCRIPT/limpiador.sh"

source "$WORKSCRIPT/Apps/0_Main.sh"
source "$WORKSCRIPT/Personalizar/Configurar_GIT.sh"
source "$WORKSCRIPT/Personalizar/Personalización_GTK.sh"
source "$WORKSCRIPT/Personalizar/Tipografías.sh"
source "$WORKSCRIPT/Personalizar/Variables_Entorno.sh"
source "$WORKSCRIPT/Servidores/0_Main.sh"
source "$WORKSCRIPT/variables.sh"

## TOFIX → Refactorizar servidores en subdirectorio con menú propio
## TOFIX → Refactorizar Personalización en subdirectorio añadiendo menú propio
#source 'Servidores/0_Main.sh'
#source 'Personalizar/0_Main.sh'


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
        echo -e "$AZ Versión del script →$RO $VERSION$CL"
        opciones "$descripcion"

        echo -e "$RO"
        read -p '    Acción → ' entrada
        echo -e "$CL"

        case ${entrada} in

            1) agregar_repositorios;;     ## Menú de Repositorios
            2) menuAplicaciones;;         ## Menú de Aplicaciones
            3) instalar_configuraciones;; ## Menú de Configuraciones
            4) #menuPersonalizacion;;     ## Menú de Personalización
               ## TOFIX → Las siguientes funciones deben quedar en Personalizar/
               configuracion_git
               personalizar
               agregar_fuentes
               instalar_variables;;
            5) menuServidores;;           ## Menú de Servidores
            6) agregar_repositorios       ## Todos los pasos anteriores
               menuAplicaciones -a        ## Indica con "-a" que ejecute todas
               instalar_configuraciones
               configuracion_git
               personalizar
               agregar_fuentes
               instalar_variables
               menuServidores -a;;        ## Indica con "-a" que ejecute todas


            0) ## SALIR
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
