#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      tecnico@fryntiz.es
## @web        www.fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

############################
##       CONSTANTES       ##
############################
AM="\033[1;33m"  ## Color AM
AZ="\033[1;34m"  ## Color Azul
BL="\033[1;37m"  ## Color Blanco
CY="\033[1;36m"  ## Color Cyan
GR="\033[0;37m"  ## Color CL
MA="\033[1;35m"  ## Color Magenta
RO="\033[1;31m"  ## Color RO
VE="\033[1;32m"  ## Color VE
CL="\e[0m"       ## Limpiar colores

#############################
##   Variables Generales   ##
#############################

############################
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################
function server_apache() {
    function instalar_apache() {
        echo -e "$VE Instalando$RO Apache2$CL"
        sudo apt install -y apache2 >> /dev/null 2>> /dev/null
        sudo apt install -y libapache2-mod-perl2 >> /dev/null 2>> /dev/null
        sudo apt install -y libapache2-mod-php >> /dev/null 2>> /dev/null
        sudo apt install -y libapache2-mod-python >> /dev/null 2>> /dev/null
    }

    function configurar_apache() {
        echo -e "$VE Preparando configuracion de$RO Apache2$CL"

        echo -e "$VE Activando módulos$RO"
        sudo a2enmod rewrite

        echo -e "$VE Desactivando módulos$RO"
        sudo a2dismod php5
    }

    function personalizar_apache() {
        clear
        echo -e "$VE Personalizando$RO Apache2$CL"
        function generar_www() {
            mi_usuario=`whoami`

            # Borrar contenido de /var/www
            sudo systemctl stop apache2
            echo -e "$VE Cuidado, esto puede$RO BORRAR$VE algo valioso"
            read -p " ¿Quieres borrar todo el directorio /var/www/? s/N → " input
            if [ $input = 's' ] || [ $input = 'S' ]
            then
                sudo rm -R /var/www/*
            else
                echo -e "$VE No se borra /var/www$AM"
            fi

            # Copia todo el contenido WEB a /var/www
            echo -e "$VE Copiando contenido dentro de /var/www"
            sudo cp -R ./Apache2/www/* /var/www/

            # Copia todo el contenido de configuración a /etc/apache2
            echo -e "$VE Copiando archivos de configuración dentro de /etc/apache2"
            sudo cp -R ./Apache2/etc/apache2/* /etc/apache2/

            # Crear archivo de usuario con permisos para directorios restringidos
            echo -e "$VE Creando usuario con permisos en apache"
            sudo rm /var/www/.htpasswd 2>> /dev/null
            while [ -z $input_user ]
            do
                read -p "Nombre de usuario para acceder al sitio web privado → " input_user
            done
            echo -e "$VE Introduce la contraseña para el sitio privado:$RO"
            sudo htpasswd -c /var/www/.htpasswd $input_user

            # Cambia el dueño
            echo -e "$VE Asignando dueños$CL"
            sudo chown www-data:www-data -R /var/www
            sudo chown root:root /etc/apache2/ports.conf

            # Agrega el usuario al grupo www-data
            echo -e "$VE Añadiendo el usuario al grupo$RO www-data"
            sudo adduser $mi_usuario www-data
        }

        echo -e "$VE Es posible generar una estructura dentro de /var/www"
        echo -e "$VE Ten en cuenta que esto borrará el contenido actual"
        echo -e "$VE También se modificarán archivos en /etc/apache2/*$RO"
        read -p " ¿Quieres Generar la estructura y habilitarla? s/N → " input
        if [ $input = 's' ] || [ $input = 'S' ]
        then
            generar_www
        else
            echo -e "$VE No se genera la estructura predefinida y automática"
        fi

        # Generar enlaces (desde ~/web a /var/www)
        function enlaces() {
            clear
            echo -e "$VE Puedes generar un enlace en tu home ~/web hacia /var/www/html"
            read -p " ¿Quieres generar el enlace? s/N → " input
            if [ $input = 's' ] || [ $input = 'S' ]
            then
                sudo ln -s /var/www/html/ /home/$mi_usuario/web
                sudo chown -R $mi_usuario:www-data /home/$mi_usuario/web
            else
                echo -e "$VE No se crea enlace desde ~/web a /var/www/html"
            fi

            clear
            echo -e "$VE Puedes crear un directorio para repositorios GIT en tu directorio personal"
            echo -e "$VE Una vez creado se añadirá un enlace al servidor web"
            echo -e "$VE Este será desde el servidor /var/www/html/Publico/GIT a ~/GIT$RO"
            read -p " ¿Quieres crear el directorio y generar el enlace? s/N → " input
            if [ $input = 's' ] || [ $input = 'S' ]
            then
                mkdir ~/GIT 2>> /dev/null && echo -e "$VE Se ha creado el directorio ~/GIT" || echo -e "$VE No se ha creado el directorio ~/GIT"
                sudo ln -s /home/$mi_usuario/GIT /var/www/html/Publico/GIT
                sudo chown -R $mi_usuario:www-data /home/$mi_usuario/GIT
            else
                echo -e "$VE No se crea enlaces ni directorio ~/GIT"
            fi
        }

        enlaces

        # Cambia los permisos
        echo -e "$VE Asignando permisos"
        sudo chmod 775 -R /var/www/*
        sudo chmod 700 /var/www/.htpasswd
        sudo chmod 700 /var/www/html/Privado/.htaccess
        sudo chmod 700 /var/www/html/Publico/.htaccess
        sudo chmod 700 /var/www/html/Privado/CMS/.htaccess
        sudo chmod 755 /etc/apache2/ports.conf /etc/apache2/
        sudo chmod 755 -R /etc/apache2/sites-available /etc/apache2/sites-enabled

        # Habilita Sitios Virtuales (VirtualHost)
        sudo a2ensite default.conf
        sudo a2ensite publico.conf
        sudo a2ensite privado.conf

        # Deshabilita Sitios Virtuales (VirtualHost)
        sudo a2dissite 000-default.conf

        function activar_hosts() {
            echo -e "$VE Añadiendo Sitios Virtuales$AM"
            echo "127.0.0.1 privado" | sudo tee -a /etc/hosts
            echo "127.0.0.1 privado.local" | sudo tee -a /etc/hosts
            echo "127.0.0.1 p.local" | sudo tee -a /etc/hosts
            echo "127.0.0.1 publico" | sudo tee -a /etc/hosts
            echo "127.0.0.1 publico.local" | sudo tee -a /etc/hosts
        }

        read -p " ¿Quieres añadir sitios virtuales a /etc/hosts? s/N → " input
        if [ $input = 's' ] || [ $input = 'S' ]
        then
            activar_hosts
        else
            echo -e "$VE No se añade nada a /etc/hosts"
        fi
    }

    instalar_apache
    configurar_apache
    personalizar_apache

    # Reiniciar servidor Apache para aplicar configuración
    sudo systemctl start apache2
    sudo systemctl restart apache2
}

function server_php() {
        V_PHP="7.0"  # Versión de PHP instalada en el sistema

    function instalar_php() {
        echo -e "$VE Instalando PHP$CL"
        paquetes_basicos="php php-cli libapache2-mod-php"
        sudo apt install -y $paquetes_basicos >> /dev/null 2>> /dev/null

        echo -e "$VE Instalando paquetes extras$AM"
        paquetes_extras="php-gd php-curl php-pgsql php-sqlite3 sqlite sqlite3 php-intl php-mbstring php-xml php-xdebug php-json"
        sudo apt install -y $paquetes_extras >> /dev/null 2>> /dev/null

        echo -e "$VE Instalando librerías$AM"
        sudo apt install -y composer >> /dev/null 2>> /dev/null
        #composer global require --prefer-dist friendsofphp/php-cs-fixer squizlabs/php_codesniffer yiisoft/yii2-coding-standards phpmd/phpmd
    }

    function configurar_php() {
        echo -e "$VE Preparando configuracion de PHP$CL"
        PHPINI="/etc/php/$V_PHP/apache2/php.ini"  # Ruta al archivo de configuración de PHP con apache2

        # Modificar configuración
        echo -e "$VE Estableciendo zona horaria por defecto para PHP$CL"
        sudo sed -r -i "s/^;?\s*date\.timezone\s*=.*$/date\.timezone = 'UTC'/" $PHPINI

        echo -e "$VE Activando Reportar todos los errores → 'error_reporting'$CL"
        sudo sed -r -i "s/^;?\s*error_reporting\s*=.*$/error_reporting = E_ALL/" $PHPINI

        echo -e "$VE Activando Mostrar errores → 'display_errors'$CL"
        sudo sed -r -i "s/^;?\s*display_errors\s*=.*$/display_errors = On/" $PHPINI

        echo -e "$VE Activando Mostrar errores al iniciar → 'display_startup_errors'$CL"
        sudo sed -r -i "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = On/" $PHPINI

        # Activar módulos
        echo -e "$VE Activando módulos$CL"
        sudo a2enmod "php$V_PHP"
        sudo phpenmod -s apache2 xdebug

        echo -e "$VE Desactivando Módulos"
        # xdebug para PHP CLI no tiene sentido y ralentiza
        sudo phpdismod -s cli xdebug
    }

    function personalizar_php() {
        echo -e "$VE Personalizando PHP$CL"

        function psysh() {
            function descargar_psysh() {
                echo -e "$VE Descargando Intérprete$RO PsySH$AM"

                REINTENTOS=10
                for (( i=1; i<=$REINTENTOS; i++ ))
                do
                    rm $WORKSCRIPT/TMP/psysh 2>> /dev/null
                    wget --show-progress https://git.io/psysh -O $WORKSCRIPT/TMP/psysh && break
                done

                # Manual
                for (( i=1; i<=$REINTENTOS; i++ ))
                do
                    rm $WORKSCRIPT/TMP/php_manual.sqlite 2>> /dev/null
                    wget --show-progress -q http://psysh.org/manual/es/php_manual.sqlite -O $WORKSCRIPT/TMP/psysh/php_manual.sqlite && break
                done
            }

            function instalar_psysh() {
                echo -e "$VE Instalando Intérprete$RO PsySH$AM"
                cp $WORKSCRIPT/TMP/psysh ~/.local/bin/psysh
                chmod +x ~/.local/bin/psysh

                # Manual
                echo -e "$VE Instalando manual para$RO PsySH$AM"
                mkdir -p ~/.local/share/psysh 2>> /dev/null
                cp $WORKSCRIPT/TMP/php_manual.sqlite ~/.local/share/psysh/php_manual.sqlite
            }

            if [ -f ~/.local/bin/psysh ]
            then
                echo -e "$VE Ya esta$RO psysh$VE instalado en el equipo, omitiendo paso$CL"
            else
                if [ -f $WORKSCRIPT/TMP/psysh ]
                then
                    instalar_psysh
                else
                    descargar_psysh
                    instalar_psysh
                fi

                # Si falla la instalación se rellama la función tras limpiar
                if [ ! -f ~/.local/bin/psysh ]
                then
                    rm -f $WORKSCRIPT/TMP/psysh
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
        echo -e "$VE Instalando PostgreSQL$CL"
        sudo apt install -y postgresql postgresql-client >> /dev/null 2>> /dev/null
        sudo apt install -y postgresql-contrib >> /dev/null 2>> /dev/null
        sudo apt install -y postgresql-all >> /dev/null 2>> /dev/null
    }

    function configurar_sql() {
        echo -e "$VE Preparando configuracion de SQL$CL"
        POSTGRESCONF="/etc/postgresql/9.6/main/postgresql.conf"  # Archivo de configuración para postgresql

        echo -e "$VE Estableciendo intervalstyle = 'iso_8601'$CL"
        sudo sed -r -i "s/^\s*#?intervalstyle\s*=/intervalstyle = 'iso_8601' #/" $POSTGRESCONF

        echo -e "$VE Estableciendo timezone = 'UTC'$CL"
        sudo sed -r -i "s/^\s*#?timezone\s*=/timezone = 'UTC' #/" $POSTGRESCONF
    }

    function personalizar_sql() {
        echo -e "$VE Personalizando SQL$CL"
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
    echo -e "$VE Se actualizará primero las listas de repositorios"
    sudo apt update >> /dev/null 2>> /dev/null
    server_apache
    server_php
    server_sql

    echo -e "$VE Se ha completado la instalacion, configuracion y personalizacion de servidores"
}
