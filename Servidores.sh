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

###########################
##       FUNCIONES       ##
###########################
server_apache() {
    instalar_apache() {
        echo -e "$VE Instalando$RO Apache2$CL"
        local dependencias="apache2 libapache2-mod-perl2 libapache2-mod-php libapache2-mod-python"
        instalarSoftware "$dependencias"
    }

    configurar_apache() {
        echo -e "$VE Preparando configuracion de$RO Apache2$CL"

        echo -e "$VE Activando módulos$RO"
        sudo a2enmod rewrite

        echo -e "$VE Desactivando módulos$RO"
        sudo a2dismod php5
    }

    personalizar_apache() {
        clear
        echo -e "$VE Personalizando$RO Apache2$CL"
        generar_www() {
            ## Borrar contenido de /var/www
            sudo systemctl stop apache2
            echo -e "$VE Cuidado, esto puede$RO BORRAR$VE algo valioso$RO"
            read -p " ¿Quieres borrar todo el directorio /var/www/? s/N → " input
            if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
                sudo rm -R /var/www/*
            else
                echo -e "$VE No se borra$RO /var/www$CL"
            fi

            ## Copia todo el contenido WEB a /var/www
            echo -e "$VE Copiando contenido dentro de /var/www"
            sudo cp -R $WORKSCRIPT/Apache2/www/* /var/www/

            ## Copia todo el contenido de configuración a /etc/apache2
            echo -e "$VE Copiando archivos de configuración dentro de /etc/apache2"
            sudo cp -R $WORKSCRIPT/Apache2/etc/apache2/* '/etc/apache2/'

            ## Crear archivo de usuario con permisos para directorios restringidos
            echo -e "$VE Creando usuario con permisos en apache"
            sudo rm /var/www/.htpasswd 2>> /dev/null
            while [[ -z "$input_user" ]]; do
                read -p "Nombre de usuario para acceder al sitio web privado → " input_user
            done
            echo -e "$VE Introduce la contraseña para el sitio privado:$RO"
            sudo htpasswd -c /var/www/.htpasswd $input_user

            ## Cambia el dueño
            echo -e "$VE Asignando dueños$CL"
            sudo chown www-data:www-data -R /var/www
            sudo chown root:root /etc/apache2/ports.conf

            ## Agrega el usuario al grupo www-data
            echo -e "$VE Añadiendo el usuario al grupo$RO www-data"
            sudo adduser "$USER" 'www-data'
        }

        echo -e "$VE Es posible generar una estructura dentro de /var/www"
        echo -e "$VE Ten en cuenta que esto borrará el contenido actual"
        echo -e "$VE También se modificarán archivos en /etc/apache2/*$RO"
        read -p " ¿Quieres Generar la estructura y habilitarla? s/N → " input
        if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
            generar_www
        else
            echo -e "$VE No se genera la estructura predefinida y automática"
        fi

        ## Generar enlaces (desde ~/web a /var/www)
        enlaces() {
            clear
            echo -e "$VE Puedes generar un enlace en tu home ~/web hacia /var/www/html"
            read -p " ¿Quieres generar el enlace? s/N → " input
            if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
                sudo ln -s '/var/www/html/' "/home/$USER/web"
                sudo chown -R "$USER:www-data" "/home/$USER/web"
            else
                echo -e "$VE No se crea enlace desde ~/web a /var/www/html"
            fi

            clear
            echo -e "$VE Puedes crear un directorio para repositorios$RO GIT$VE en tu directorio personal"
            echo -e "$VE Una vez creado se añadirá un enlace al servidor web"
            echo -e "$VE Este será desde el servidor /var/www/html/Publico/GIT a ~/GIT$RO"
            read -p " ¿Quieres crear el directorio y generar el enlace? s/N → " input
            if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
                if [[ ! -d "$HOME/GIT" ]]; then
                    echo -e "$VE Creando directorio$RO $HOME/GIT$VE"
                    mkdir "$HOME/GIT"
                fi

                ## TOFIX:
                ## Comprobar si existen enlaces antes de hacer el siguiente paso
                sudo ln -s "$HOME/GIT" '/var/www/html/Publico/GIT'
                sudo ln -s "$HOME/GIT" "$HOME/git"
                sudo chown -R "$USER:www-data" '/home/$USER/GIT'
            else
                echo -e "$VE No se crea enlaces ni directorio ~/GIT"
            fi
        }

        enlaces

        ## Cambia los permisos
        echo -e "$VE Asignando permisos"
        ## TOFIX → Función para los permisos
        sudo chmod 775 -R /var/www/*
        sudo chmod 700 '/var/www/.htpasswd'
        sudo chmod 700 '/var/www/html/Privado/.htaccess'
        sudo chmod 700 '/var/www/html/Publico/.htaccess'
        sudo chmod 700 '/var/www/html/Privado/CMS/.htaccess'
        sudo chmod 755 '/etc/apache2/ports.conf' '/etc/apache2/'
        sudo chmod 755 -R '/etc/apache2/sites-available' '/etc/apache2/sites-enabled'

        ## Habilita Sitios Virtuales (VirtualHost)
        sudo a2ensite 'default.conf'
        sudo a2ensite 'publico.conf'
        sudo a2ensite 'privado.conf'

        ## Deshabilita Sitios Virtuales (VirtualHost)
        sudo a2dissite '000-default.conf'

        activar_hosts() {
            echo -e "$VE Añadiendo$RO Sitios Virtuales$AM"
            echo '127.0.0.1 privado' | sudo tee -a '/etc/hosts'
            echo '127.0.0.1 privado.local' | sudo tee -a '/etc/hosts'
            echo '127.0.0.1 p.local' | sudo tee -a '/etc/hosts'
            echo '127.0.0.1 publico' | sudo tee -a '/etc/hosts'
            echo '127.0.0.1 publico.local' | sudo tee -a '/etc/hosts'
        }

        read -p " ¿Quieres añadir sitios virtuales a /etc/hosts? s/N → " input
        if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]; then
            activar_hosts
        else
            echo -e "$VE No se añade nada a$RO /etc/hosts$CL"
        fi
    }

    instalar_apache
    configurar_apache
    personalizar_apache

    ## Reiniciar servidor Apache para aplicar configuración
    sudo systemctl start apache2
    sudo systemctl restart apache2
}

server_php() {
    ## TOFIX → Autogenerar lista de versiones php instalados en el sistema
    V_PHP="7.0"  ## Versión de PHP instalada en el sistema

    instalar_php() {
        echo -e "$VE Instalando$RO PHP$CL"
        paquetes_basicos="php php-cli libapache2-mod-php"
        instalarSoftware "$paquetes_basicos"

        echo -e "$VE Instalando$RO paquetes extras$AM"
        paquetes_extras="php-gd php-curl php-pgsql php-sqlite3 sqlite sqlite3 php-intl php-mbstring php-xml php-xdebug php-json"
        instalarSoftware "$paquetes_extras"

        echo -e "$VE Instalando librerías$AM"
        instalarSoftware composer
        #composer global require --prefer-dist friendsofphp/php-cs-fixer squizlabs/php_codesniffer yiisoft/yii2-coding-standards phpmd/phpmd
    }

    configurar_php() {
        echo -e "$VE Preparando configuracion de$RO PHP$CL"
        local PHPINI="/etc/php/$V_PHP/apache2/php.ini"  # Ruta al archivo de configuración de PHP con apache2

        ## Modificar configuración
        echo -e "$VE Estableciendo zona horaria por defecto para PHP$CL"
        sudo sed -r -i "s/^;?\s*date\.timezone\s*=.*$/date\.timezone = 'UTC'/" $PHPINI

        echo -e "$VE Activando Reportar todos los errores → 'error_reporting'$CL"
        sudo sed -r -i "s/^;?\s*error_reporting\s*=.*$/error_reporting = E_ALL/" $PHPINI

        echo -e "$VE Activando Mostrar errores → 'display_errors'$CL"
        sudo sed -r -i "s/^;?\s*display_errors\s*=.*$/display_errors = On/" $PHPINI

        echo -e "$VE Activando Mostrar errores al iniciar → 'display_startup_errors'$CL"
        sudo sed -r -i "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = On/" $PHPINI

        ## Activar módulos
        echo -e "$VE Activando módulos$CL"
        sudo a2enmod "php$V_PHP"
        sudo phpenmod -s apache2 xdebug

        echo -e "$VE Desactivando Módulos"
        ## Xdebug para PHP CLI no tiene sentido y ralentiza
        sudo phpdismod -s cli xdebug
    }

    personalizar_php() {
        echo -e "$VE Personalizando PHP$CL"

        psysh() {
            descargar_psysh() {
                echo -e "$VE Descargando Intérprete$RO PsySH$AM"
                ## Descargar PsySH
                descargar 'psysh' 'https://git.io/psysh'
                ## Descargar Manual para PsySH
                descargar 'php_manual.sqlite' 'http://psysh.org/manual/es/php_manual.sqlite'
            }

            instalar_psysh() {
                echo -e "$VE Instalando Intérprete$RO PsySH$AM"
                cp "$WORKSCRIPT/tmp/psysh" "$HOME/.local/bin/psysh"
                chmod +x "$HOME/.local/bin/psysh"

                ## Manual
                echo -e "$VE Instalando manual para$RO PsySH$AM"
                if [[ -d "$HOME/.local/share/psysh" ]]; then
                    mkdir -p "$HOME/.local/share/psysh"
                fi
                cp "$WORKSCRIPT/tmp/php_manual.sqlite" "$HOME/.local/share/psysh/php_manual.sqlite"
            }

            if [[ -f "$HOME/.local/bin/psysh" ]]
            then
                echo -e "$VE Ya esta$RO psysh$VE instalado en el equipo,$AM omitiendo paso$CL"
            else
                if [[ -f "$WORKSCRIPT/tmp/psysh" ]]; then
                    instalar_psysh
                else
                    descargar_psysh
                    instalar_psysh
                fi
            fi
        }

        psysh
    }

    ## Preparar archivo con parámetros para xdebug
    echo -e "$VE Configurando$RO Xdebug$VE para PHP$CL"
    echo 'zend_extension=xdebug.so
    xdebug.remote_enable=1
    xdebug.remote_host=127.0.0.1
    #xdebug.remote_connect_back=1    # Not safe for production servers
    xdebug.remote_port=9000
    xdebug.remote_handler=dbgp
    xdebug.remote_mode=req
    xdebug.remote_autostart=true
    ' | sudo tee "/etc/php/$V_PHP/apache2/conf.d/20-xdebug.ini"

    instalar_php
    configurar_php
    personalizar_php

    ## Reiniciar apache2 para hacer efectivos los cambios
    reiniciarServicio apache2
}

server_sql() {
    instalar_sql() {
        echo -e "$VE Instalando$RO PostgreSQL$CL"
        local dependencias="postgresql postgresql-client postgresql-contrib postgresql-all"

        ## Instalando dependencias
        instalarSoftware "$dependencias"
    }

    configurar_sql() {
        echo -e "$VE Preparando configuracion de$RO SQL$CL"
        ## TOFIX → Detectar todas las versionesde postgresql y aplicar cambios por cada versión encontrada en el sistema.

        ## Versión de PostgreSQL
        local V_PSQL='9.6'

        ## Archivo de configuración para postgresql
        local POSTGRESCONF="/etc/postgresql/$V_PSQL/main/postgresql.conf"

        echo -e "$VE Estableciendo intervalstyle = 'iso_8601'$CL"
        sudo sed -r -i "s/^\s*#?intervalstyle\s*=/intervalstyle = 'iso_8601' #/" "$POSTGRESCONF"

        echo -e "$VE Estableciendo timezone = 'UTC'$CL"
        sudo sed -r -i "s/^\s*#?timezone\s*=/timezone = 'UTC' #/" "$POSTGRESCONF"
    }

    personalizar_sql() {
        echo -e "$VE Personalizando SQL$CL"
        #sudo -u postgres createdb basedatos #Crea la base de datos basedatos
        #sudo -u postgres createuser -P usuario #Crea el usuario usuario y pide que teclee su contraseña
    }

    instalar_sql
    configurar_sql
    personalizar_sql

    ## Reiniciar servidor postgresql al terminar con la instalación y configuración
    reiniciarServicio 'postgresql'
}

instalar_servidores() {
    prepararInstalador

    server_apache
    server_php
    server_sql

    echo -e "$VE Se ha completado la instalacion, configuracion y personalizacion de servidores"
}
