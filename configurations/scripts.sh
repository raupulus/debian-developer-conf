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
##      INSTRUCTIONS      ##
############################
##

###########################
##       FUNCTIONS       ##
###########################

function configurations_scripts_raspberry() {
    addScriptToBin 'rpi_camera_capture_image'
    addScriptToBin 'rpi_camera_capture_video'
    addScriptToBin 'rpi_read_temp'

    # TODO → Este es .py, adaptar función para estos casos
    #addScriptToBin 'rpi_control_fan_temp_gpio'
}

function configurations_scripts_macos() {
    echo -e "$VE Añadiendo scripts para $ROmacos$CL"
}

function configurations_scripts_generic() {
    addScriptToBin 'check_apache_and_start'
    addScriptToBin 'check_mysql_and_start'
    addScriptToBin 'check_postgresql_and_start'
    addScriptToBin 'gocd_laravel_link_storage'
    addScriptToBin 'gocd_laravel_rebuild'
    addScriptToBin 'gocd_publish_apache'
    addScriptToBin 'php_version_select'
    addScriptToBin 'scripts_info'
    addScriptToBin 'telegram_send_message'
    addScriptToBin 'telegram_send_message_watch_file'
    addScriptToBin 'backup_all_files_server_vps'
}

configurations_scripts() {
    echo -e "$VE Añadiendo scripts a$RO /bin$CL"

    if [[ "${DISTRO}" = 'macos' ]]; then
        configurations_scripts_macos
    else
        configurations_scripts_generic
    fi

    if [[ "${MY_DISTRO}" = 'raspbian' ]]; then
        echo -e "$VE Añadiendo scripts de raspbian a$RO /bin$CL"
        configurations_scripts_raspberry
    fi
}
