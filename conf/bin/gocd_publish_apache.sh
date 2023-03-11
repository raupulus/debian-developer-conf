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

# $1 → PROJECT_NAME: *
# $2 → VISIBILITY: public|private

echo "Param1: ${1}"
echo "Param2: ${2}"

ls -al

if [[ ${1} = '' ]]; then
    echo -e 'Es obligatorio un nombre para el proyecto'
    exit 1
fi

VISIBITLIY='public'

if [[ ${2} = 'private' ]]; then
    VISIBITLIY='private'
fi

PATH_ORIGIN="${PWD}"
PATH_APACHE="/var/www/${VISIBITLIY}"
PROJECT_NAME="${1}"

echo "El directorio de trabajo es ${PWD}"
echo "El directorio de destino para apache es ${PATH_APACHE}/${PROJECT_NAME}"

## Compruebo si existe el directorio del proyecto, la primera vez no existirá.
if [[ ! -d "${PATH_APACHE}/${PROJECT_NAME}" ]]; then
    mkdir -p "${PATH_APACHE}/${PROJECT_NAME}"
fi

## Cuando se haya creado el directorio se reemplaza contenido.
if [[ -d "${PATH_APACHE}/${PROJECT_NAME}" ]]; then
    echo -e "Copiando artifacts"
    rm -rf ${PATH_APACHE}/${PROJECT_NAME}/
    cp -R ${PATH_ORIGIN}/ "${PATH_APACHE}/${PROJECT_NAME}"
fi


## Añado configuración para apache2.
if [[ -f "${PATH_ORIGIN}/apache.conf" ]] &&
   [[ ! -f "/etc/apache2/sites-available/${PROJECT_NAME}.conf" ]];
then

    echo -e "Estableciendo configuración de apache"
    cp "${PATH_ORIGIN}/apache.conf" "/etc/apache2/sites-available/${PROJECT_NAME}.conf"

fi

## Creo directorio de logs para apache
#if [[ ! -d "/var/log/apache2/${PROJECT_NAME}" ]]; then
#    mkdir -p "/var/log/apache2/${PROJECT_NAME}"
#fi

exit 0
