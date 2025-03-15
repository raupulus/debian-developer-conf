#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-style-guide

############################
##      INSTRUCTIONS      ##
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

## Importo variables globales para evitar conflictos de configuración sin reboot
if [[ -f '/etc/environment' ]]; then
    source '/etc/environment'
fi

DEBIAN_FRONTEND=noninteractive  ## Deshabilita carteles del instalador

DEBUG='false'      ## Establece si está el script en modo depuración
WORKSCRIPT=$PWD  ## Directorio principal del script
PATH_LOG="$WORKSCRIPT/errors.log"  ## Archivo donde almacenar errores

## Importo variables locales si existieran, sobreescriben a las globales
if [[ -a "$WORKSCRIPT/.env" ]]; then
    source "$WORKSCRIPT/.env"
fi

if [[ -f "$HOME/.gnupg" ]]; then
    chmod -R 700 "$HOME/.gnupg"
fi


USER=$(whoami)   ## Usuario que ejecuta el script
VERSION='0.8.14'  ## Versión en desarrollo
MY_DISTRO="$DISTRO"  ## Distribución sobre la que se ejecuta
MY_BRANCH="$BRANCH"  ## stable|testing|unstable
MY_ENV="$ENV"    ## prod|dev desde /etc/environment o .env

## Importo variables con rutas de directorios para configuraciones.
source "$WORKSCRIPT/routes.sh"

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/functions.sh"
source "$WORKSCRIPT/preferences.sh"
source "$WORKSCRIPT/limpiador.sh"

source "$WORKSCRIPT/Apps/0_Main.sh"
source "$WORKSCRIPT/configurations/0_Main.sh"
source "$WORKSCRIPT/Personalizar/0_Main.sh"
source "$WORKSCRIPT/servers/0_Main.sh"
source "$WORKSCRIPT/Repositorios/0_Main.sh"
source "$WORKSCRIPT/Lenguajes-Programacion/0_Main.sh"
source "$WORKSCRIPT/Desktops/0_Main.sh"
source "$WORKSCRIPT/Usuario/0_Main.sh"
source "$WORKSCRIPT/root/0_Main.sh"
source "$WORKSCRIPT/VPS/0_Main.sh"
source "$WORKSCRIPT/raspberry/0_Main.sh"

###########################
##       VARIABLES       ##
###########################

## Esta función configura las variables globales.
configurePreferences

## Seteo las rutas para los directorios.
setAllRoutes

## Esta variable depende de ejecutarse primero el script anterior.
SOFTLIST="${WORKSCRIPT}/Software-Lists/${MY_DISTRO}"  ## Ruta a listas de software

## Registro en logs si se entra en desarrollo.
if [[ "${DEBUG}" = 'true' ]]; then
  log 'Se ha ejecutado el script en modo DEBUG'
fi


## Previene en debian testing (probablemente superiores también) que no pregunte
## a cada instalación si deseamos reiniciar servicios.
#export DEBIAN_FRONTEND=noninteractive

###########################
##      PARAMETERS       ##
###########################
if [[ "$1" = 'vim' ]]; then
    vim_installer
    exit 0
fi

if [[ "$1" = 'nano' ]]; then
    user_nano_installer
    exit 0
fi

if [[ "$1" = 'terminals' ]]; then
    user_terminals_installer
    exit 0
fi


###########################
##     DEPENDENCIES      ##
###########################
if [[ ! -f '/usr/bin/sudo' ]]; then
    echo 'Necesitas instalar "sudo"'
    echo 'Hazlo con tu gestor de paquetes, por ejemplo: apt install sudo'
    exit 1
fi

###########################
##       FUNCIONES       ##
###########################
menuPrincipal() {
    while true :; do
        clear_screen

        local descripcion='Menú Principal
            1) Repositorios
            2) Aplicaciones
            3) Configuraciones del Sistema
            4) Personalización del Entorno
            5) Servidores
            6) Lenguajes de Programación
            7) Configurar este Usuario
            8) Todos los pasos anteriores a la vez

            9) Desktops
            10) Configurar root
            11) Configurar VPS
            12) Configurar Raspberry (Scripts adicionales)

            0) Salir
        '
        echo -e "$AZ Versión del script →$RO $VERSION$CL"
        opciones "$descripcion"

        echo -e "$RO"
        read -p '    Acción → ' entrada
        echo -e "$CL"

        case ${entrada} in

            1) menuRepositorios;;          ## Menú de Repositorios
            2) menuAplicaciones;;          ## Menú de Aplicaciones
            3) menu_configurations;;        ## Menú de Configuraciones
            4) menuPersonalizacion;;       ## Menú de Personalización
            5) menuServidores;;            ## Menú de Servidores
            6) menuLenguajes;;
            7) menuUsuario;;
            8) menuRepositorios           ## Todos los pasos
               menuAplicaciones -a
               menu_configurations -a
               menuPersonalizacion -a
               menuServidores -a
               menuLenguajes -a;;
            9) menuDesktops;;
            10) menu_root;;
            11) menuVPS;;
            12) menu_raspberry;;

            0) ## SALIR
              clear_screen
              echo -e "$RO Se sale del menú$CL"
              echo ''
              exit 0;;

            *)  ## Acción ante entrada no válida
              clear_screen
              echo ""
              echo -e "                   $RO ATENCIÓN: Elección no válida$CL";;
        esac
    done
}

###########################
##       EJECUCIÓN       ##
###########################
menuPrincipal
