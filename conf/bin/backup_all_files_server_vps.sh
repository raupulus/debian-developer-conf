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
##
## Genera un backup de los directorios establecidos en la lista comprimiendo
## y organizando en un directorio el resultado de los backups.
##
## Parámetros que puede recibir
## $1 → Tipo de acción (-p para setear propietario del grupo de backups por defecto)
## $2 → Valor para la acción de $1
##

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

## Compruebo en este punto si es root quien lo ejecuta o aborta el script.
if [[ "${USER}" != 'root' ]]; then
    echo -e "${RO}Este script solo se puede ejecutar como root, prueba con sudo.${CL}"
    exit 1
fi

############################
##       VARIABLES        ##
############################

FILES_EXCLUDES='node_modules' #TODO → Implementar exclusiones

PATHS_BACKUPS=('/etc' '/var/www/storage' '/var/lib/go-server' '/usr/share/go-server' '/var/lib/go-agent' '/usr/share/go-agent')

PATHS_BACKUPS_FILES=() #TODO → Implementar backups de archivos concretos, go-server y go-client no se necesita salvar al completo

## Archivo en el que se guardarán logs
PATH_LOG='/var/log'
LOG_FILE="${PATH_LOG}/vps-backup-all-files.log"

## Directorio temporal para preparar el backup.
PATH_TMP_PREPARE_BACKUP='/tmp/vps-prepare-backup'

## Ruta para guardar el backup final.
PATH_STORE_BACKUP='/var/backups/vps-files-backups'

## Nombre del backup resultante
BACKUP_NAME="Backup-$(date +%F_%H.%M.%S)"

## Número de días para mantener los backups.
DAYS_OF_SAVE_BACKUPS=120

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
## Copia todos los archivos al directorio de trabajo
##
copyFilesToWorkPath() {

    ## Recorre cada directorio para preparar el backup
    for DIR in "${PATHS_BACKUPS[@]}"; do

        ## Compruebo si existe el directorio antes de copiarlo
        if [[ -d "${DIR}" ]]; then
            echo -e "${VE}Copiando el directorio ${RO}${DIR}${CL}"
            echo "Copiando el directorio ${DIR}" >> $LOG_FILE


            #TODO → copiar con "rsync" excluyendo archivos
            #rsync -a --exclude={'file1.txt','dir1/*','dir2'} "${DIR}/" "${PATH_TMP_PREPARE_BACKUP}/"

            mkdir -p "${PATH_TMP_PREPARE_BACKUP}/${DIR}"
            rsync -a "${DIR}" "${PATH_TMP_PREPARE_BACKUP}/${DIR}/"

        else
            echo -e "${RO}No existe el directorio ${DIR}${CL}"
            echo "No existe el directorio ${DIR}" >> $LOG_FILE
        fi

    done
}

##
## Comprime el backup y lo almacena en su ruta final.
##
compressAndMoveBackup() {
    echo -e "${VE}Comprimiendo Backup${CL}"
    echo "Comprimiendo Backup" >> $LOG_FILE

    ## Comprimiendo backup
    tar czvf "${PATH_STORE_BACKUP}/${BACKUP_NAME}.tar.gz" "${PATH_TMP_PREPARE_BACKUP}"
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

    ## Directorio para los backups.
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

    ## Directorio para las bases de datos postgresql.
    chown :$group -R "${PATH_STORE_BACKUP}"
    chmod g+s -R "${PATH_STORE_BACKUP}"

    ## Establezco el grupo por defecto para todos los subdirectorios.
    find "${PATH_STORE_BACKUP}" -type d -exec chmod g+s {} +
}

############################
##       EJECUCIÓN        ##
############################

#TODO → Comprobar dependencias: rsync, tar

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
    copyFilesToWorkPath
    compressAndMoveBackup
    cleanWorkPath
    fixPermissions
fi



FINISH_TIME=$(date +%F_%X)

echo "Finish: ${FINISH_TIME}" >> $LOG_FILE
echo >> $LOG_FILE
echo '-----------------------------------------' >> $LOG_FILE

echo -e "${AM}Comienzo del script: ${RO}${START_TIME}${CL}"
echo -e "${AM}Finalización del script: ${RO}${FINISH_TIME}${CL}"

exit 0
