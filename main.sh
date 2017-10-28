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


#############################
##   Variables Generales   ##
#############################


while :
    do
        sleep 1
        clear
        echo ""
        echo -e "   $rojo 0)  $verde Salir$gris"
        echo -e "   $rojo 1)  $verde Instalar Aplicaciones Básicas y agregar Repositorios$gris"
        echo -e "   $rojo 2)  $verde Agregar Tipografías$gris"
        echo -e "   $rojo 3)  $verde Instalar Configuraciones$gris" #Configuración bash, zsh, variables entorno...
        echo -e "   $rojo 4)  $verde Configurar GIT$gris"
        echo -e "   $rojo 5)  $verde Personalizar Sistema y GTK$gris"
        echo -e "   $rojo 6)  $verde Instalar Servidores Apache → PHP → SQL"
        echo -e "   $rojo 7)  $verde Ejecutar todos los pasos anteriores$gris"


    read entrada
    case $entrada in

        1)#Instalar Aplicaciones Básicas
            clear
            echo -e "$verde Instalar Aplicaciones Básicas$gris"
            agregar_repositorios
            instalar_Software
            read -p "Pulsa una tecla para continuar";;

        2)#Agregar Tipografías
            clear
            echo -e "$verde Agregar Tipografías$gris"
            agregar_fuentes
            read -p "Pulsa una tecla para continuar";;

        3)#Instalar Configuraciones
            clear
            echo -e "$verde Instalar Configuraciones$gris"
            instalar_configuraciones
            instalar_variables
            read -p "Pulsa una tecla para continuar";;

        4)#Configurar GIT
            clear
            echo -e "$verde Configurar GIT$gris"
            configuracion_git
            read -p "Pulsa una tecla para continuar";;

        5)#Personalizar GTK
            clear
            echo -e "$verde Personalizar Entorno t GTK$gris"
            personalizar
            read -p "Pulsa una tecla para continuar";;

        6)#Servidores
            clear
            echo -e "$verde Instalando servidores Apache → PHP → SQL$gris"
            instalar_servidores
            read -p "Pulsa una tecla para continuar";;

        7)#Todas configuraciones
            clear
            echo -e "$verde Preparando para aplicar todas las configuraciones en serie$gris"
            agregar_repositorios
            instalar_Software
            agregar_fuentes
            instalar_configuraciones
            configuracion_git
            personalizar
            instalar_servidores
            instalar_variables
            read -p "Pulsa una tecla para continuar";;

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
