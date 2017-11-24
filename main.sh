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
source ./Instalar_Software_Extra.sh
source ./Instalar_Software_Usuario.sh
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
        echo -e "   $rojo 1)  $verde Agregar Repositorios$gris"
        echo -e "   $rojo 2)  $verde Instalar Aplicaciones Básicas$gris"
        echo -e "   $rojo 3)  $verde Instalar Aplicaciones Extras$gris"
        echo -e "   $rojo 4)  $verde Instalar Aplicaciones de Usuario$gris"
        echo -e "   $rojo 5)  $verde Instalar Configuraciones$gris" #Configuración bash, zsh, variables entorno...
        echo -e "   $rojo 6)  $verde Agregar Tipografías$gris"
        echo -e "   $rojo 7)  $verde Configurar GIT$gris"
        echo -e "   $rojo 8)  $verde Personalizar Sistema y GTK$gris"
        echo -e "   $rojo 9)  $verde Instalar Servidores Apache → PHP → SQL"
        echo -e "   $rojo all)  $verde Ejecutar todos los pasos anteriores$gris"
        echo -e "   $rojo CLEAN)  $amarillo Limpia$rojo TODO$amarillo rastro del script (peligroso) $gris"


    echo -e "$rojo"
    read -p "    Acción → " entrada
    echo -e "$gris"

    case $entrada in

        1)#Agregar Repositorios
            clear
            echo -e "$verde Agregando Repositorios Debian Stable$gris"
            agregar_repositorios
            read -p "Pulsa una tecla para continuar";;

        2)#Instalar Aplicaciones Básicas
            clear
            echo -e "$verde Instalar Aplicaciones Básicas$gris"
            instalar_Software
            read -p "Pulsa una tecla para continuar";;

        3)#Instalar Aplicaciones Extras
            clear
            echo -e "$verde Instalar Aplicaciones Extras$gris"
            instalar_Software_Extra
            read -p "Pulsa una tecla para continuar";;

        4)#Instalar Aplicaciones de Usuario
            clear
            echo -e "$verde Instalar Aplicaciones de Usuario$gris"
            instalar_Software_Usuario
            read -p "Pulsa una tecla para continuar";;

        5)#Instalar Configuraciones
            clear
            echo -e "$verde Instalar Configuraciones$gris"
            instalar_configuraciones
            instalar_variables
            read -p "Pulsa una tecla para continuar";;

        6)#Agregar Tipografías
            clear
            echo -e "$verde Agregar Tipografías$gris"
            agregar_fuentes
            read -p "Pulsa una tecla para continuar";;

        7)#Configurar GIT
            clear
            echo -e "$verde Configurar GIT$gris"
            configuracion_git
            read -p "Pulsa una tecla para continuar";;

        8)#Personalizar GTK
            clear
            echo -e "$verde Personalizar Entorno t GTK$gris"
            personalizar
            read -p "Pulsa una tecla para continuar";;

        9)#Servidores
            clear
            echo -e "$verde Instalando servidores Apache → PHP → SQL$gris"
            instalar_servidores
            read -p "Pulsa una tecla para continuar";;

        all | ALL)#Todas configuraciones
            clear
            echo -e "$verde Preparando para aplicar todas las configuraciones en serie$gris"
            agregar_repositorios
            instalar_Software
            instalar_Software_Extra
            instalar_Software_Usuario
            instalar_configuraciones
            agregar_fuentes
            configuracion_git
            personalizar
            instalar_servidores
            instalar_variables
            read -p "Pulsa una tecla para continuar";;

        celan | CLEAN)  # Borrar todo rastro del script, es muy peligroso usarlo
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
