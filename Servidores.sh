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
DIR_SCRIPT=`echo $PWD`

function server_apache() {

    function instalar_apache() {
        echo -e "$verde Instalando Apache$rojo 2$gris"
        sudo apt install -y apache2 >> /dev/null 2>> /dev/null
        sudo apt install -y libapache2-mod-perl2 >> /dev/null 2>> /dev/null
        sudo apt install -y libapache2-mod-php >> /dev/null 2>> /dev/null
        sudo apt install -y libapache2-mod-python >> /dev/null 2>> /dev/null
    }

    function configurar_apache() {
        echo -e "$verde Preparando configuracion de$rojo Apache 2$gris"

        echo -e "$verde Activando módulos$red"
        sudo a2enmod rewrite

        echo -e "$verde Desactivando módulos$red"
        sudo a2dismod php5
    }

    function personalizar_apache() {
        clear
        echo -e "$verde Personalizando$rojo Apache 2$gris"
        function generar_www() {
            mi_usuario=`whoami`

            # ¿Borrar contenido de /var/www?
            sudo rm -R /var/www/*

            # Copia todo el contenido WEB a /var/www
            echo -e "$verde Copiando contenido dentro de /var/www"
            sudo cp -R ./Apache2/www/* /var/www/

            # Copia todo el contenido de configuración a /etc/apache2
            echo -e "$verde Copiando archivos de configuración dentro de /etc/apache2"
            sudo cp -R ./Apache2/etc/apache2/* /etc/apache2/

            # Crear archivo de usuarios con permisos para directorios restringidos
            echo -e "$verde Creando usuarios con permisos en apache"
            sudo rm /var/www/.htpasswd 2>> /dev/null
            while [ -z $input_user ]
            do
                read -p "Nombre de usuario para acceder al sitio web privado → " input_user
            done
            echo -e "$verde Introduce la contraseña para el sitio privado:$rojo"
            sudo htpasswd -c /var/www/.htpasswd $input_user

            # Cambia el dueño
            echo -e "$verde Asignando dueños$gris"
            sudo chown www-data:www-data -R /var/www
            sudo chown root:root /etc/apache2/ports.conf

            # Agrega al usuario al grupo www-data
            echo -e "$verde Añadiendo el usuario al grupo$rojo www-data"
            sudo adduser $mi_usuario www-data
        }

        echo -e "$verde Es posible generar una estructura dentro de /var/www"
        echo -e "$verde Ten en cuenta que esto borrará el contenido actual"
        echo -e "$verde También se modificarán archivos en /etc/apache2/*$red"
        read -p " ¿Quieres Generar la estructura y habilitarla? s/N → " input
        if [ $input = 's' ] || [ $input = 'S' ]
        then
            generar_www
        fi

        # Generar enlaces (desde ~/web a /var/www)
        function enlaces() {
            clear
            echo -e "$verde Puedes generar un enlace en tu home ~/web hacia /var/www/"
            read -p " ¿Quieres generar el enlace? s/N → " input
            if [ $input = 's' ] || [ $input = 'S' ]
            then
                sudo ln -s /var/www/ /home/$mi_usuario/web
                sudo chown -R $mi_usuario:www-data /home/$mi_usuario/web
            fi

            clear
            echo -e "$verde Puedes crear un directorio para repositorios GIT en tu directorio personal"
            echo -e "$verde Una vez creado se añadirá un enlace al servidor web"
            echo -e "$verde Este será desde el servidor /var/www/GIT a ~/GIT$rojo"
            read -p " ¿Quieres crear el directorio y generar el enlace? s/N → " input
            if [ $input = 's' ] || [ $input = 'S' ]
            then
                mkdir ~/GIT 2>> /dev/null && echo -e "$verde Se ha creado el directorio ~/GIT" || echo -e "$verde No se ha creado el directorio ~/GIT"
                sudo ln -s /home/$mi_usuario/GIT /var/www/Publico/GIT
                sudo chown -R $mi_usuario:www-data /home/$mi_usuario/GIT
            fi
        }

        enlaces

        # Cambia los permisos
        echo -e "$verde Asignando permisos"
        sudo chmod 775 -R /var/www/*
        sudo chmod 700 /var/www/.htpasswd
        sudo chmod 700 /var/www/Privado/.htaccess
        sudo chmod 700 /var/www/Publico/.htaccess
        sudo chmod 700 /var/www/Privado/CMS/.htaccess
        sudo chmod 755 /etc/apache2/ports.conf /etc/apache2/
        sudo chmod 755 -R /etc/apache2/sites-available /etc/apache2/sites-enabled

        # Habilita Sitios Virtuales (VirtualHost)
        sudo a2ensite publico.conf
        sudo a2ensite privado.conf

        # Deshabilita Sitios Virtuales (VirtualHost)
        sudo a2dissite 000-default.conf
    }

    instalar_apache
    configurar_apache
    personalizar_apache

    # Reiniciar servidor Apache para aplicar configuración
    sudo systemctl restart apache2
}

function server_php() {
        V_PHP="7.0"  # Versión de PHP instalada en el sistema

    function instalar_php() {
        echo -e "$verde Instalando PHP$gris"
        paquetes_basicos="php php-cli libapache2-mod-php"
        sudo apt install -y $paquetes_basicos >> /dev/null 2>> /dev/null

        echo -e "$verde Instalando paquetes extras$yellow"
        paquetes_extras="php-gd php-curl php-pgsql php-sqlite3 sqlite sqlite3 php-intl php-mbstring php-xml php-xdebug php-json"
        sudo apt install -y $paquetes_extras >> /dev/null 2>> /dev/null

        echo -e "$verde Instalando librerías$yellow"
        sudo apt install -y composer >> /dev/null 2>> /dev/null
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

        function psysh() {
            function descargar_psysh() {
                echo -e "$verde Descargando Intérprete$rojo PsySH$amarillo"

                REINTENTOS=10
                for (( i=1; i<=$REINTENTOS; i++ ))
                do
                    rm $DIR_SCRIPT/TMP/psysh 2>> /dev/null
                    wget --show-progress https://git.io/psysh -O $DIR_SCRIPT/TMP/psysh && break
                done


                wget --show-progress https://git.io/psysh -O $DIR_SCRIPT/TMP/psysh
            }

            function instalar_psysh() {
                echo -e "$verde Instalando Intérprete$rojo PsySH$amarillo"
                cp $DIR_SCRIPT/TMP/psysh ~/.local/bin/psysh
                chmod +x ~/.local/bin/psysh
            }

            if [ -f ~/.local/bin/psysh ]
            then
                echo -e "$verde Ya esta$rojo psysh$verde instalado en el equipo, omitiendo paso$gris"
            else
                if [ -f $DIR_SCRIPT/TMP/psysh ]
                then
                    instalar_psysh
                else
                    descargar_psysh
                    instalar_psysh
                fi

                # Si falla la instalación se rellama la función tras limpiar
                if [ ! -f ~/.local/bin/psysh ]
                then
                    rm -f $DIR_SCRIPT/TMP/psysh
                    descargar_psysh
                    instalar_psysh
                fi
            fi
        }

        psysh
    }
    # Preparar archivo con parámetros para xdebug
    echo 'zend_extension=xdebug.so
    xdebug.remote_enable=1
    xdebug.remote_host=127.0.0.1
    #xdebug.remote_connect_back=1    # Not safe for production servers
    xdebug.remote_port=9000
    xdebug.remote_handler=dbgp
    xdebug.remote_mode=req
    xdebug.remote_autostart=true
    ' | sudo tee /etc/php/$V_PHP/apache2/conf.d/20-xdebug.ini

    instalar_php
    configurar_php
    personalizar_php

    # Reiniciar apache2 para hacer efectivos los cambios
    sudo systemctl restart apache2
}

function server_sql() {

    function instalar_sql() {
        echo -e "$verde Instalando PostgreSQL$gris"
        sudo apt install -y postgresql postgresql-client >> /dev/null 2>> /dev/null
        sudo apt install -y postgresql-contrib >> /dev/null 2>> /dev/null
        sudo apt install -y postgresql-all >> /dev/null 2>> /dev/null
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
