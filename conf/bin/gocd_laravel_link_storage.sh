#!/bin/bash

## Este script crea un enlace dentro del storage en /var/www/storage/
## Recibe como parámetros:
## $1 $PROJECT_NAME
## $2 $VISIBILITY: public|private

echo "Param1: ${1}"
echo "Param2: ${2}"

PATH_ORIGIN="$(pwd)"

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

## Cuando no existe almacenamiento se copia la primera vez.
if [[ ! -d "/var/www/storage/${PROJECT_NAME}" ]]; then
    mv "${PATH_APACHE}/${PROJECT_NAME}/storage" "/var/www/storage/${PROJECT_NAME}"
    chmod 775 -R "/var/www/storage/${PROJECT_NAME}"
    chown www-data:www-data "/var/www/storage/${PROJECT_NAME}"
else
    rm -Rf "${PATH_APACHE}/${PROJECT_NAME}/storage"
fi

## Crea enlace simbólico hacia el almacenamiento del proyecto
ln -s "/var/www/storage/${PROJECT_NAME}" "${PATH_APACHE}/${PROJECT_NAME}/storage"

if [[ ! -f "/var/www/public/${PROJECT_NAME}/public/storage" ]]; then
    ln -s "/var/www/storage/${PROJECT_NAME}/app/public" "${PATH_APACHE}/${PROJECT_NAME}/public/storage"
fi
