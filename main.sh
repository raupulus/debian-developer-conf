#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

# Script principal
# Desde aquí se llamaran a todos los demás scripts separando funciones para cada uno de ellos
#
# Ten en cuenta que este script hace modificaciones en el equipo a mi gusto
# Puede no funcionar correctamente si usas software de repositorios externo
# Probablemente no funcionará en otras distribuciones distintas a Debian rama Stable

############################
##   Constantes Colores   ##
############################
amarillo="\033[1;33m"
azul="\033[1;34m"
blanco="\033[1;37m"
cyan="\033[1;36m"
gris="\033[0;37m"
magenta="\033[1;35m"
rojo="\033[1;31m"
verde="\033[1;32m"


#############################
##    Importar Fuentes     ##
#############################

source ./Agregar_Repositorios.sh
source ./Instalar_Software.sh
source ./Tipografías.sh
source ./Instalar_Configuraciones.sh
source ./Variables_Entorno.sh
source ./Configurar_GIT.sh
source ./Personalización_GTK.sh
source ./Servidores.sh
source ./limpiador.sh


#############################
##   Variables Generales   ##
#############################
DIR_SCRIPT=`echo $PWD`

if [ ! -d 'TMP' ]
then
    mkdir TMP
fi


while :
    do
        sleep 1
        clear
        echo ""
        echo -e "   $rojo 0)  $verde Salir$gris"
        echo -e "   $rojo 1)  $verde Instalar Configuraciones$gris" #Configuración bash, zsh, variables entorno...
        echo -e "   $rojo 2)  $verde Agregar Repositorios$gris"
        echo -e "   $rojo 3)  $verde Instalar Aplicaciones Básicas$gris"
        echo -e "   $rojo 4)  $verde Agregar Tipografías$gris"
        echo -e "   $rojo 5)  $verde Configurar GIT$gris"
        echo -e "   $rojo 6)  $verde Personalizar Sistema y GTK$gris"
        echo -e "   $rojo 7)  $verde Instalar Servidores Apache → PHP → SQL"
        echo -e "   $rojo 8)  $verde Ejecutar todos los pasos anteriores$gris"
        echo -e "   $rojo 999)  $amarillo Limpia$rojo TODO$amarillo rastro del script (peligroso) $gris"


    echo -e "$rojo"
    read -p "    Acción → " entrada
    echo -e "$gris"

    case $entrada in

        1)#Instalar Configuraciones
            clear
            echo -e "$verde Instalar Configuraciones$gris"
            instalar_configuraciones
            instalar_variables
            read -p "Pulsa una tecla para continuar";;

        2)#Agregar Repositorios
            clear
            echo -e "$verde Agregando Repositorios Debian Stable$gris"
            agregar_repositorios
            read -p "Pulsa una tecla para continuar";;

        3)#Instalar Aplicaciones Básicas
            clear
            echo -e "$verde Instalar Aplicaciones Básicas$gris"
            instalar_Software
            read -p "Pulsa una tecla para continuar";;

        4)#Agregar Tipografías
            clear
            echo -e "$verde Agregar Tipografías$gris"
            agregar_fuentes
            read -p "Pulsa una tecla para continuar";;

        5)#Configurar GIT
            clear
            echo -e "$verde Configurar GIT$gris"
            configuracion_git
            read -p "Pulsa una tecla para continuar";;

        6)#Personalizar GTK
            clear
            echo -e "$verde Personalizar Entorno t GTK$gris"
            personalizar
            read -p "Pulsa una tecla para continuar";;

        7)#Servidores
            clear
            echo -e "$verde Instalando servidores Apache → PHP → SQL$gris"
            instalar_servidores
            read -p "Pulsa una tecla para continuar";;

        8)#Todas configuraciones
            clear
            echo -e "$verde Preparando para aplicar todas las configuraciones en serie$gris"
            agregar_repositorios
            instalar_configuraciones
            instalar_Software
            agregar_fuentes
            configuracion_git
            personalizar
            instalar_servidores
            instalar_variables
            read -p "Pulsa una tecla para continuar";;

        999)  # Borrar todo rastro del script, es muy peligroso usarlo
            clear
            echo -e "$rojo Preparando para limpiar todo rastro$gris"
            echo -e "$rojo Esto solo es útil ante situaciones donde fallan cosas$gris"
            echo -e "$rojo Hay riesgo de perder datos$gris"
            limpiar_con_fuerza
            echo "";;

        0)#SALIR
            clear
            echo -e "$rojo Se sale del menú$gris"
            echo ""
            exit 0;;

        *)#Opción no válida
            clear
            echo ""
            echo -e "                      $rojo ATENCIÓN: Elección no válida$gris"
    esac
done
