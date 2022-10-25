#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-

## @author     Raúl Caro Pastorino
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
## @telegram   https://t.me/fryntiz

## @bash        5.1 or later
## Create Date: 2022
## Project Name:
## Description:
## Dependencies:

##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

## Revision 0.01 - File Created
## Additional Comments:

## @license    https://wwww.gnu.org/licenses/gpl.txt
## @copyright  Copyright © 2022 Raúl Caro Pastorino
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>


############################
##      INSTRUCTIONS      ##
############################
##
## Genera una copia de seguridad por cada base de datos mysql en un
## archivo comprimido en tar.gz independiente por cada una de ellas y además
## agrupadas en un directorio con el nombre de la base de datos.
## También se limpian los backups que tienen muchos días de obsoletos
##
## Parámetros que puede recibir
## $1 → Tipo de acción (-p para setear propietario del grupo de backups por defecto)
## $2 → Valor para la acción de $1
##
## Para restaurar una db:
## mysql -u root -p --default-character-set=utf8 < db.sql

############################
##     IMPORTACIONES      ##
############################

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

VERSION="0.0.1"
WORKSCRIPT=$PWD  ## Directorio principal del script
USER=$(whoami)   ## Usuario que ejecuta el script

## Compruebo en este pungo si es root quien lo ejecuta o aborta el script.
if [[ "${USER}" != 'root' ]]; then
    echo -e "${RO}Este script solo se puede ejecutar como root, prueba con sudo.${CL}"
    exit 1
fi

############################
##       VARIABLES        ##
############################

## Archivo en el que se guardarán logs.
PATH_LOG='/var/log'
LOG_FILE="${PATH_LOG}/mysql-db-backup.log"

## Directorio temporal para preparar el backup.
PATH_TMP_PREPARE_BACKUP='/tmp/mysql-prepare-backup'

## Ruta dónde se almacenan los backups para las bases de datos.
PATH_STORE_DATABASES='/var/backups/databases'

## Ruta para guardar el backup final.
PATH_STORE_BACKUP="${PATH_STORE_DATABASES}/mysql"

## Fecha del backup para concatenarla en el nombre.
BACKUP_DATE="$(date +%F_%H.%M.%S)"

## Número de días para mantener los backups.
DAYS_OF_SAVE_BACKUPS=120

## Nombres de las bases de datos. TODO → Mirar role, a ver como generalizarlo
DATABASES=$(mysql -u root -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)

############################
##       FUNCIONES        ##
############################
##
## Prepara los directorios de trabajo antes de comenzar.
##
createDirectories() {
    ## Creo el directorio temporal si no existe o limpio su contenido.
    if [[ ! -d "${PATH_TMP_PREPARE_BACKUP}" ]]; then
        mkdir -p "${PATH_TMP_PREPARE_BACKUP}"
    else
        rm -Rf "${PATH_TMP_PREPARE_BACKUP}"
        mkdir -p "${PATH_TMP_PREPARE_BACKUP}"
    fi

    ## Directorio para guardar el backup final.
    if [[ ! -d "${PATH_STORE_BACKUP}" ]]; then
        mkdir -p "${PATH_STORE_BACKUP}"
    fi

    ## Directorio para guardar logs
    if [[ ! -d "${PATH_LOG}" ]]; then
        mkdir -p "${PATH_LOG}"
    fi

    ## Crea el archivo de logs si no existe
    if [[ ! -f "${LOG_FILE}" ]]; then
        touch "${LOG_FILE}"
    fi
}

##
## Exporta todas las bases de datos que no son del sistema mysql.
##
dump_databases() {
    for db in $DATABASES; do
        if [[ "${db}" != 'information_schema' ]] &&
           [[ "${db}" != 'performance_schema' ]] &&
           [[ "${db}" != 'mysql' ]] &&
           [[ "${db}" != _* ]]; then

        echo -e "${VE}Exportando DB: ${RO}${db}${CL}"

        local parameters='--databases'

        mysqldump -u root ${parameters} $db > "${PATH_TMP_PREPARE_BACKUP}/${db}_${BACKUP_DATE}.sql"

        compressAndMoveBackup "${PATH_TMP_PREPARE_BACKUP}/${db}_${BACKUP_DATE}.sql" "${db}"
      fi
    done
}

##
## Comprime el backup y lo almacena en su ruta final.
##
## $1 La ruta hacia la db exportada en .sql
## $2 El nombre de la db
##
compressAndMoveBackup() {
    local FILE_TO_COMPRESS=$1
    local DB_NAME=$2

    echo -e "${VE}Comprimiendo DB mysql: ${RO}${DB_NAME}${CL}"
    echo "Comprimiendo DB mysql: ${DB_NAME}" >> $LOG_FILE

    ## Creo el directorio para agrupar los backups de la db destino
    if [[ ! -d "${PATH_STORE_BACKUP}/${DB_NAME}" ]]; then
        mkdir -p "${PATH_STORE_BACKUP}/${DB_NAME}"
    fi

    local parameters='--force --best -c'

    ## Comprimiendo backup
    gzip $parameters "${FILE_TO_COMPRESS}" > "${PATH_STORE_BACKUP}/${DB_NAME}/${DB_NAME}_${BACKUP_DATE}.gz"
}

##
## Limpia el directorio de trabajo.
##
cleanWorkPath() {
    if [[ -d "${PATH_TMP_PREPARE_BACKUP}" ]]; then
        echo -e "${VE}Limpiando directorio de trabajo${CL}"
        echo 'Limpiando directorio de trabajo' >> $LOG_FILE

        rm -rf "${PATH_TMP_PREPARE_BACKUP}"
    fi
}

##
## Elimina las copias de seguridad viejas
##
deleteOldBackups() {
    echo -e "${VE}Eliminando backups con más de ${RO}${DAYS_OF_SAVE_BACKUPS}${VE} días${CL}"
    echo "Eliminando backups con más de ${DAYS_OF_SAVE_BACKUPS} días" >> $LOG_FILE
    find "${PATH_STORE_BACKUP}" -type f -prune -mtime +$DAYS_OF_SAVE_BACKUPS -exec rm -f {} \;
}

##
## Prepara los permisos para el directorio de backups y los backups en si.
##
fixPermissions() {
    echo -e "${VE}Securizando directorio de backups${CL}"
    echo 'Securizando directorio de backups' >> $LOG_FILE

    ## Directorio para todas las bases de datos.
    chmod 750 "${PATH_STORE_DATABASES}"
    umask 027 "${PATH_STORE_DATABASES}"

    ## Directorio para las bases de datos mysql.
    chmod 750 -R "${PATH_STORE_BACKUP}"
    umask 027 -R "${PATH_STORE_BACKUP}"
}

##
## Establece un grupo por defecto para los directorios de backups
##
## $1 Es el nombre del grupo.
##
setDefaultGroup() {
    local group="$1"

    echo -e "${VE}Estableciendo backups para el grupo: ${RO}${group}${CL}"
    echo -e "Estableciendo backups para el grupo: ${group}" >> LOG_FILE

    ## Directorio para todas las bases de datos.
    chown :$group "${PATH_STORE_DATABASES}"
    chmod g+s "${PATH_STORE_DATABASES}"

    ## Directorio para las bases de datos mysql.
    chown :$group -R "${PATH_STORE_BACKUP}"
    chmod g+s -R "${PATH_STORE_BACKUP}"

    ## Establezco el grupo por defecto para todos los subdirectorios.
    find "${PATH_STORE_BACKUP}" -type d -exec chmod g+s {} +
}

############################
##       EJECUCIÓN        ##
############################

#TODO → Comprobar dependencias: gzip, pg_dump

START_TIME=$(date +%F_%X)
echo >> $LOG_FILE
echo '-----------------------------------------' >> $LOG_FILE
echo "Start: ${START_TIME}" >> $LOG_FILE

if [[ "$1" = '-p' ]]; then
    if [[ -z "$2" ]]; then
        echo -e "${RO}Se necesita pasar el nombre del grupo: -p mygroup${CL}"
        exit 1
    fi

    createDirectories
    setDefaultGroup $2
    fixPermissions
else
    createDirectories
    dump_databases
    cleanWorkPath
    deleteOldBackups
    fixPermissions
fi

FINISH_TIME=$(date +%F_%X)

echo "Finish: ${FINISH_TIME}" >> $LOG_FILE
echo >> $LOG_FILE
echo '-----------------------------------------' >> $LOG_FILE

echo -e "${AM}Comienzo del script: ${RO}${START_TIME}${CL}"
echo -e "${AM}Finalización del script: ${RO}${FINISH_TIME}${CL}"

exit 0
