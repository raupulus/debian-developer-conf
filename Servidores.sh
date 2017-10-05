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

function server_apache() {

    function instalar_apache() {
    echo -e "$verde Instalando Apache 2$gris"
    }

    function configurar_apache() {
    echo -e "$verde Preparando configuracion de Apache 2$gris"
    }

    function personalizar_apache() {
    echo -e "$verde Personalizando Apache 2$gris"
    }

    instalar_apache
    configurar_apache
    personalizar_apache
}

function server_php() {

    function instalar_php() {
    echo -e "$verde Instalando PHP 2$gris"
        sudo apt install php libapache2-mod-php php-cli php-pgsql php-sqlite3 sqlite php-intl php-mbstring php-gd php-curl php-xml php-xdebug php-json
    }

    function configurar_php() {
    echo -e "$verde Preparando configuracion de PHP 2$gris"
    }

    function personalizar_php() {
    echo -e "$verde Personalizando PHP 2$gris"
    }

    instalar_php
    configurar_php
    personalizar_php
}

function server_sql() {

    function instalar_sql() {
    echo -e "$verde Instalando SQL 2$gris"
        sudo apt install postgresql postgresql-client postgresql-contrib postgresql-all
    }

    function configurar_sql() {
    echo -e "$verde Preparando configuracion de SQL 2$gris"
    }

    function personalizar_sql() {
    echo -e "$verde Personalizando SQL 2$gris"
        #sudo -u postgres createdb basedatos #Crea la base de datos basedatos
        #sudo -u postgres createuser -P usuario #Crea el usuario usuario y pide que teclee su contraseña
    }

    instalar_sql
    configurar_sql
    personalizar_sql
}

function instalar_servidores() {
    server_apache
    server_php
    server_sql

    echo -e "$verde Se ha completado la instalacion, configuracion y personalizacion de servidores"
}
