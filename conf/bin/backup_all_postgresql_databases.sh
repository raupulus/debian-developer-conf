#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-

## @author     Raúl Caro Pastorino
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
## @telegram   https://t.me/fryntiz

## @bash        4.2 or later
## Create Date: 2021
## Project Name:
## Description:
## Dependencies:

##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

## Revision 0.01 - File Created
## Additional Comments:

## @license    https://wwww.gnu.org/licenses/gpl.txt
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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

############################
##       VARIABLES        ##
############################

## Archivo en el que se guardarán logs.
PATH_LOG='/var/log'
LOG_FILE="${PATH_LOG}/postgresql-db-backup.log"

## Directorio temporal para preparar el backup.
PATH_TMP_PREPARE_BACKUP='/tmp/postgresql-prepare-backup'

## Ruta para guardar el backup final.
PATH_STORE_BACKUP='/var/backups/databases/postgresql'

## Fecha del backup para concatenarla en el nombre.
BACKUP_DATE="$(date +%F_%X)"

## Número de días para mantener los backups.
DAYS_OF_SAVE_BACKUPS=120

## Nombres de las bases de datos. TODO → Mirar role, a ver como generalizarlo
DATABASES=$(psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d')

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
## Exporta todas las bases de datos que no son del sistema postgresql.
##
dump_databases() {
    for db in $DATABASES; do
        if [
            [ "${db}" != 'postgres' ] &&
            [ "${db}" != 'template0' ] &&
            [ "${db}" != 'template1' ] &&
            [ "${db}" != 'template_postgis' ]
        ]; then
        echo -e "${VE}Exportando DB: ${RO}${db}${CL}"

        pg_dump $db > "${PATH_TMP_PREPARE_BACKUP}/${db}_${BACKUP_DATE}.sql"

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

    echo -e "${VE}Comprimiendo DB Postgresql: ${RO}${DB_NAME}${CL}"
    echo "Comprimiendo DB Postgresql: ${DB_NAME}" >> $LOG_FILE

    ## Comprimiendo backup
    tar czvf "${PATH_STORE_BACKUP}/${DB_NAME}_${BACKUP_DATE}.tar.gz" "${FILE_TO_COMPRESS}"
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
    find "${PATH_STORE_BACKUP}" -type f -prune -mtime +$DAYS_OF_SAVE_BACKUPS -exec rm -f {} \;
}

############################
##       EJECUCIÓN        ##
############################

START_TIME=$(date +%F_%X)
echo >> $LOG_FILE
echo '-----------------------------------------' >> $LOG_FILE
echo "Start: ${START_TIME}" >> $LOG_FILE

createDirectories
dump_databases
cleanWorkPath
deleteOldBackups

FINISH_TIME=$(date +%F_%X)

echo "Finish: ${FINISH_TIME}" >> $LOG_FILE
echo >> $LOG_FILE
echo '-----------------------------------------' >> $LOG_FILE

echo -e "${AM}Comienzo del script: ${RO}${START_TIME}${CL}"
echo -e "${AM}Finalización del script: ${RO}${FINISH_TIME}${CL}"

exit 0
