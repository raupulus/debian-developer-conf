#!/bin/bash


## Este script da retoques finales a un proyecto laravel
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

cd "${PATH_APACHE}/${PROJECT_NAME}"

composer install --no-dev
npm install production

chown www-data:www-data -R "${PATH_APACHE}/${PROJECT_NAME}"

