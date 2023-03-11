#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

###########################
##       FUNCTIONS       ##
###########################

##
## Envía un mensaje y/o archivo para enviarlo por telegram
##
## Recibe como parámetros:
## $1 = $file Archivo o ruta hacia este.
##

file="${1}"
md5_new="$(md5sum ${file})"
md5_validate="false"
group='Raupulus_IOT'

## Compruebo si existe suma de verificación md5 o la creo.
if [[ -f "${file}.md5" ]];then
    md5="$(cat ${file}.md5)"

    if [[ "${md5}" = "${md5_new}" ]]; then
        ## Marco que valida, no hay cambios en el archivo.
        md5_validate="true"
    else
        ## Añado el nuevo hash.
        echo "${md5_new}" > "${file}.md5"
    fi
else
    echo "${md5_new}" > "${file}.md5"
fi

## En caso de no validar, hay cambios y envío el archivo.
if [[ "${md5_validate}" = 'false' ]]; then
    ## Envío mensajes por telegram.
    /usr/bin/telegram-cli/telegram-cli -W -e "msg $group Modificado archivo: ${file}"
    /usr/bin/telegram-cli/telegram-cli -W -e "send_file $group '$file'"

    ## Envío notificaciones de escritorio
    notify-send "File ${file} sent to Group: ${group}";
fi
