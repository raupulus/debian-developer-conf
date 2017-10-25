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
        sudo apt install -y apache2
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
        echo -e "$verde Instalando PHP$gris"
        paquetes_basicos="php php-cli libapache2-mod-php"
        sudo apt install -y $paquetes_basicos

        echo -e "$verde Instalando paquetes extras$gris"
        paquetes_extras="php-gd php-curl php-pgsql php-sqlite3 sqlite sqlite3 php-intl php-mbstring php-xml php-xdebug php-json"
        sudo apt install -y $paquetes_extras

        echo -e "$verde Instalando librerías$gris"
        sudo apt install -y composer
        #composer global require --prefer-dist friendsofphp/php-cs-fixer squizlabs/php_codesniffer yiisoft/yii2-coding-standards phpmd/phpmd
    }

    function configurar_php() {
        echo -e "$verde Preparando configuracion de PHP$gris"
        PHPINI='/etc/php/7.0/apache2/php.ini'  # Ruta al archivo de configuración de PHP con apache2

        echo -e "$verde Estableciendo zona horaria por defecto para PHP$gris"
        sudo sed -r -i "s/^;?\s*date\.timezone\s*=.*$/date\.timezone = 'UTC'/" $PHPINI

        echo -e "$verde Activando Mostrar errores → 'display_errors'$gris"
        sudo sed -r -i "s/^;?\s*display_errors\s*=.*$/display_errors = On/" $PHPINI

        echo -e "$verde Activando Mostrar errores al iniciar → 'display_startup_errors'$gris"
        sudo sed -r -i "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = On/" $PHPINI
    }

    function personalizar_php() {
        echo -e "$verde Personalizando PHP$gris"
    }

    instalar_php
    configurar_php
    personalizar_php

    # Reiniciar apache2 para hacer efectivos los cambios
    systemctl restart apache2
}

function server_sql() {

    function instalar_sql() {
        echo -e "$verde Instalando PostgreSQL$gris"
        sudo apt install -y postgresql postgresql-client
        sudo apt install -y postgresql-contrib
        sudo apt install -y postgresql-all 2>> /dev/null
    }

    function configurar_sql() {
    echo -e "$verde Preparando configuracion de SQL$gris"
    }

    function personalizar_sql() {
        echo -e "$verde Personalizando SQL$gris"
        #sudo -u postgres createdb basedatos #Crea la base de datos basedatos
        #sudo -u postgres createuser -P usuario #Crea el usuario usuario y pide que teclee su contraseña
    }

    instalar_sql
    configurar_sql
    personalizar_sql
}

function instalar_servidores() {
    sudo apt update
    server_apache
    server_php
    server_sql

    echo -e "$verde Se ha completado la instalacion, configuracion y personalizacion de servidores"
}
