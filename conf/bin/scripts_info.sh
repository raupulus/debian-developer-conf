#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

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

############################
##      INSTRUCTIONS      ##
############################
## Este script solo informa de los demás, para cuando no los recuerde

############################
##       FUNCTIONS        ##
############################

## Traer scripts de mi repo → https://gitlab.com/fryntiz/shellscript/-/tree/master
## implementar script para gestionar servidores

function scripts_create_info() {
    local command=$1
    local info=$2

    echo -e "${VE}${command}:${AM} ${info}${CL}"
}

function scripts_info_general() {
    echo -e "${RO}Scripts Generales${CL}"

    scripts_create_info 'check_apache_and_start' 'Comprueba si el servidor apache está levantado, en caso de no estarlo lo reinicia'
    scripts_create_info 'check_mysql_and_start' 'Comprueba si el servidor mysql está levantado, en caso de no estarlo lo reinicia'
    scripts_create_info 'check_postgresql_and_start' 'Comprueba si el servidor postgresql está levantado, en caso de no estarlo lo reinicia'
    scripts_create_info 'gocd_laravel_link_storage' 'Gestiona enlaces con GoCd'
    scripts_create_info 'gocd_laravel_rebuild' 'Gestiona transpilar npm y composer con gocd'
    scripts_create_info 'gocd_publish_apache' 'Publica un repositorio preparado en apache con gocd'
    scripts_create_info 'php_version_select' 'Permite elegir entre versiones de php para cambiarla tanto en la versión del lenguaje como en apache'
    scripts_create_info 'telegram_send_message' 'Envía un mensaje por telegram con o sin adjunto'
    scripts_create_info 'telegram_send_message_watch_file' 'Envía un mensaje por telegram solo cuando ha cambiado el contenido comparando su hash'
}

function scripts_info_raspberry() {
    echo -e "${RO}Scripts para raspberry${CL}"
    scripts_create_info 'rpi_camera_capture_image' 'Captura una imagen'
    scripts_create_info 'rpi_camera_capture_video' 'Captura un vídeo'
    scripts_create_info 'rpi_read_temp' 'Devuelve la temperatura actual'
    scripts_create_info 'rpi_control_fan_temp_gpio' 'Enciende el ventilador si la temperatura excede el umbral haciendo uso de un GPIO'
}

function scripts_info() {
    echo ''
    echo -e "${AZ}Información sobre scripts personalizados${CL}"
    echo ''
    scripts_info_general
    echo ''
    scripts_info_raspberry
}

scripts_info
