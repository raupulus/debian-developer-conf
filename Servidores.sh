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

    echo -e "$verde Activando módulos$gris"
    sudo a2enmod rewrite

    echo -e "$verde Desactivando módulos"

    }

    function personalizar_apache() {
    echo -e "$verde Personalizando Apache 2$gris"
    }

    instalar_apache
    configurar_apache
    personalizar_apache

    # Reiniciar servidor Apache para aplicar configuración
    sudo systemctl restart apache2
}

function server_php() {

    function instalar_php() {
        V_PHP="7.0"  # Versión de PHP instalada en el sistema

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
        PHPINI="/etc/php/$V_PHP/apache2/php.ini"  # Ruta al archivo de configuración de PHP con apache2

        # Modificar configuración
        echo -e "$verde Estableciendo zona horaria por defecto para PHP$gris"
        sudo sed -r -i "s/^;?\s*date\.timezone\s*=.*$/date\.timezone = 'UTC'/" $PHPINI

        echo -e "$verde Activando Reportar todos los errores → 'error_reporting'$gris"
        sudo sed -r -i "s/^;?\s*error_reporting\s*=.*$/error_reporting = E_ALL/" $PHPINI

        echo -e "$verde Activando Mostrar errores → 'display_errors'$gris"
        sudo sed -r -i "s/^;?\s*display_errors\s*=.*$/display_errors = On/" $PHPINI

        echo -e "$verde Activando Mostrar errores al iniciar → 'display_startup_errors'$gris"
        sudo sed -r -i "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = On/" $PHPINI

        # Activar módulos
        echo -e "$verde Activando módulos$gris"
        sudo a2enmod "php$V_PHP"
        sudo phpenmod -s apache2 xdebug

        echo -e "$verde Desactivando Módulos"
        # xdebug para PHP CLI no tiene sentido y ralentiza
        sudo phpdismod -s cli xdebug
    }

    function personalizar_php() {
        echo -e "$verde Personalizando PHP$gris"

        # TODO → Implementar control si fallan las descargas en "psysh
        # Intérprete interactivo de PHP → psysh
        if [ ! -f ~/.local/bin/psysh ]
        then
            echo -e "$verde Instalando Intérprete$rojo PsySH$amarillo"
            wget --show-progress https://git.io/psysh  -O ~/.local/bin/psysh
            chmod +x ~/.local/bin/psysh
        fi

        # Instalar manual para psysh funciona así → doc nombre_función
        if [ ! -f ~/local/share/psysh/php_manual.sqlite ]
        then
            echo -e "$verde Instalando manual para$rojo PsySH$amarillo"
            mkdir -p ~/.local/share/psysh 2>> /dev/null
            wget --show-progress -q http://psysh.org/manual/es/php_manual.sqlite -O ~/.local/share/psysh/php_manual.sqlite
        fi
    }

    instalar_php
    configurar_php
    personalizar_php

    # Reiniciar apache2 para hacer efectivos los cambios
    sudo systemctl restart apache2
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
        POSTGRESCONF="/etc/postgresql/9.6/main/postgresql.conf"  # Archivo de configuración para postgresql

        echo -e "$verde Estableciendo intervalstyle = 'iso_8601'$gris"
        sudo sed -r -i "s/^\s*#?intervalstyle\s*=/intervalstyle = 'iso_8601' #/" $POSTGRESCONF

        echo -e "$verde Estableciendo timezone = 'UTC'$gris"
        sudo sed -r -i "s/^\s*#?timezone\s*=/timezone = 'UTC' #/" $POSTGRESCONF
    }

    function personalizar_sql() {
        echo -e "$verde Personalizando SQL$gris"
        #sudo -u postgres createdb basedatos #Crea la base de datos basedatos
        #sudo -u postgres createuser -P usuario #Crea el usuario usuario y pide que teclee su contraseña
    }

    instalar_sql
    configurar_sql
    personalizar_sql

    # Reiniciar servidor postgresql al terminar con la instalación y configuración
    sudo systemctl restart postgresql
}

function instalar_servidores() {
    sudo apt update
    server_apache
    server_php
    server_sql

    echo -e "$verde Se ha completado la instalacion, configuracion y personalizacion de servidores"
}
