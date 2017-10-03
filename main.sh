#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

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
##   Variables Generales   ##
#############################

source ./Agregar_Repositorios.sh
source ./Instalar_Software.sh
source ./Tipografías.sh
source ./Instalar_Configuraciones.sh
source ./Configurar_GIT.sh
source ./Personalización_GTK.sh

while :
	do
		sleep 1
		clear
		echo ""
		echo -e "   $rojo 0)  $verde Salir"
		echo -e "   $rojo 1)  $verde Instalar Aplicaciones Básicas y agregar Repositorios"
		echo -e "   $rojo 2)  $verde Agregar Tipografías"
		echo -e "   $rojo 3)  $verde Instalar Configuraciones" #Configuración bash, zsh, variables entorno...
		echo -e "   $rojo 4)  $verde Configurar GIT"
		#echo -e "   $rojo 5)  $verdeC Instalar Servidor Apache+PHP+SQL"


	read entrada
	case $entrada in

		1)#Instalar Aplicaciones Básicas
			clear
			echo "Instalar Aplicaciones Básicas"
			agregar_repositorios
			instalar_Software
			read -p "Pulsa una tecla para continuar";;

		2)#Agregar Tipografías
			clear
			echo "Agregar Tipografías"
			agregar_fuentes
			read -p "Pulsa una tecla para continuar";;

		3)#Instalar Configuraciones
			clear
			echo "Instalar Configuraciones"
			instalar_configuraciones
			read -p "Pulsa una tecla para continuar";;

		4)#Configurar GIT
			clear
			echo "Configurar GIT"
			configuracion_git
			read -p "Pulsa una tecla para continuar";;
        5)#Configurar GIT
			clear
			echo "Personalizar"
			personalizar
			read -p "Pulsa una tecla para continuar";;

		0)#SALIR
			clear
			echo -e "$rojo Se sale del menú$gris"
			echo ""
			exit 1;;

		*)#Opción no válida
			clear
			echo ""
			echo -e "                      $rojo ATENCIÓN: Elección no válida$gris"
    esac
done
