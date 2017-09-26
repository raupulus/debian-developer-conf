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

while :
	do
		sleep 1
		clear
		echo ""
		echo -e "   $rojoC 0)  $verdeC Salir"
		echo -e "   $rojoC 1)  $verdeC Instalar Aplicaciones Básicas y agregar Repositorios"
		echo -e "   $rojoC 2)  $verdeC Agregar Tipografías"
		#echo -e "   $rojoC 3)  $verdeC Instalar Configuraciones" #Configuración bash, zsh, variables entorno...
		#echo -e "   $rojoC 4)  $verdeC Configurar GIT"
		#echo -e "   $rojoC 5)  $verdeC Instalar Servidor Apache+PHP+SQL"


	read entrada
	case $entrada in

		1)#Instalar Aplicaciones Básicas
			clear
			echo "Instalar Aplicaciones Básicas"
			#agregar_repositorios
			#instalar_Software
			read -p "Pulsa una tecla para continuar";;

		2)#Agregar TipografíasC
			clear
			echo "Agregar Tipografías"
			#agregar_fuentes
			read -p "Pulsa una tecla para continuar";;

		0)#SALIR
			clear
			echo -e "$rojo Se sale del menú$grisC"
			echo ""
			exit 1;;

		*)#Opción no válida
			clear
			echo ""
			echo -e "                      $rojoC ATENCIÓN: Elección no válida$grisC"
esac
done
