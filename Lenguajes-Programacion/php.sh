#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-style-guide

############################
##     INSTRUCCIONES      ##
############################
## Instala php en su última versión estable desde repositorios y además
## configura todas las versiones instaladas en el sistema.
## Se activan módulos necesarios de apache y se corrigen posibles conflictos
## con otras versiones en archivos de configuración si hemos actualizado desde
## php 5.
## Configura Xdebug también.

############################
##        FUNCIONES       ##
############################

php_descargar() {
    echo -e "$VE Descargando$RO php$CL"
}

php_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO php"
}

php_instalar() {
    echo -e "$VE Instalando$RO php$CL"

    instalarSoftwareLista "$SOFTLIST/Lenguajes-Programacion/php.lst"
}

php_composer_latest_install() {
    echo -e "$VE Instalando la última versión de$RO Composer$CL"
    php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
    sudo php '/tmp/composer-setup.php' --install-dir='/usr/bin/' --filename='composer-latest'
}

php_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de php"

    ##
    ## Recibe la versión de PHP para configurar y modifica sus archivos
    ## @param $1 Es la versión de php dentro de /etc/php
    ##
    configurar_php() {
        echo -e "$VE Preparando configuracion de$RO PHP$CL"

        ## Ruta al archivo de configuración de PHP con apache2
        if [[ "$DISTRO" = 'debian' ]] || [[ "$DISTRO" = 'raspbian' ]]; then
            local PHPINI="/etc/php/$1/apache2/php.ini"
        elif [[ "$DISTRO" = 'fedora' ]]; then
            local PHPINI="/etc/php.ini"
        elif [[ "$DISTRO" = 'gentoo' ]]; then
            echo -e "$VE No configurado para gentoo $DISTRO$CL"
        fi

        ## Modificar configuración
        echo -e "$VE Estableciendo zona horaria por defecto para PHP$CL"
        sudo sed -r -i "s/^;?\s*date\.timezone\s*=.*$/date\.timezone = 'UTC'/" $PHPINI

        ## Configuración para desarrollo
        if [[ "$ENV" = 'dev' ]]; then
            echo -e "$VE Configurando PHP para desarrollo$CL"
            echo -e "$VE Activando Reportar todos los errores → 'error_reporting'$CL"
            sudo sed -r -i "s/^;?\s*error_reporting\s*=.*$/error_reporting = E_ALL/" $PHPINI

            echo -e "$VE Activando Mostrar errores → 'display_errors'$CL"
            sudo sed -r -i "s/^;?\s*display_errors\s*=.*$/display_errors = On/" $PHPINI

            echo -e "$VE Activando Mostrar errores al iniciar → 'display_startup_errors'$CL"
            sudo sed -r -i "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = On/" $PHPINI

        else
            echo -e "$VE Configurando PHP para producción$CL"
            echo -e "$VE Desactivando Reportar todos los errores → 'error_reporting'$CL"
            sudo sed -r -i "s/^;?\s*error_reporting\s*=.*$/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/" $PHPINI

            echo -e "$VE Desactivando Mostrar errores → 'display_errors'$CL"
            sudo sed -r -i "s/^;?\s*display_errors\s*=.*$/display_errors = Off/" $PHPINI

            echo -e "$VE Desactivando Mostrar errores al iniciar → 'display_startup_errors'$CL"
            sudo sed -r -i "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = Off/" $PHPINI
        fi

        echo -e "$VE Tiempo máximo de ejecución 5 minutos → 'max_execution_time'$CL"
        sudo sed -r -i "s/^;?\s*max_execution_time\s*=.*$/max_execution_time = 300/" $PHPINI

        echo -e "$VE Límite de Memoria por script → 'memory_limit = 256M'$CL"
        sudo sed -r -i "s/^;?\s*memory_limit\s*=.*$/memory_limit = 256M/" $PHPINI

        ## Límite de archivos
        echo -e "$VE Tamaño máximo de subida → 'upload_max_filesize = 1024M'$CL"
        sudo sed -r -i "s/^;?\s*upload_max_filesize\s*=.*$/upload_max_filesize = 1024M/" $PHPINI

        echo -e "$VE Tamaño máximo de POST → 'post_max_size = 1024M'$CL"
        sudo sed -r -i "s/^;?\s*post_max_size\s*=.*$/post_max_size = 1024M/" $PHPINI
    }

    personalizar_php() {
        echo -e "$VE Personalizando PHP$CL"

        ## Descargar e instalar Psysh y su manual en Español
        psysh() {
            echo -e "$VE Descargando e instalando$RO PsySH$CL"
            if [[ -f "$HOME/.local/bin/psysh" ]]; then
                rm -f "$HOME/.local/bin/psysh"
            fi

            if [[ ! -f "$WORKSCRIPT/tmp/psysh" ]]; then
                descargar 'psysh' 'https://psysh.org/psysh'
            fi

            cp "$WORKSCRIPT/tmp/psysh" "$HOME/.local/bin/psysh"
            chmod +x "$HOME/.local/bin/psysh"

            echo -e "$VE Instalando manual para$RO PsySH$AM"
            if [[ -f "$HOME/.local/share/psysh/php_manual.sqlite" ]]; then
                rm -f "$HOME/.local/share/psysh/php_manual.sqlite"
            fi

            if [[ ! -d "$HOME/.local/share/psysh" ]]; then
                mkdir -p "$HOME/.local/share/psysh"
            fi

            if [[ ! -f "$WORKSCRIPT/tmp/php_manual.sqlite" ]]; then
                descargar 'php_manual.sqlite' 'http://psysh.org/manual/es/php_manual.sqlite'
            fi

            cp "$WORKSCRIPT/tmp/php_manual.sqlite" "$HOME/.local/share/psysh/php_manual.sqlite"
        }

        if [[ "$ENV" = 'dev' ]]; then
            psysh
        fi
    }

    ## Preparar archivo con parámetros para xdebug
    xdebug() {
        echo -e "$VE Configurando$RO Xdebug$VE para PHP$CL"
        echo 'zend_extension=xdebug.so
        xdebug.remote_enable=1
        xdebug.remote_host=127.0.0.1
        #xdebug.remote_connect_back=1    # Not safe for production servers
        xdebug.remote_port=9000
        xdebug.remote_handler=dbgp
        xdebug.remote_mode=req
        xdebug.remote_autostart=true
        ' | sudo tee "/etc/php/$1/apache2/conf.d/20-xdebug.ini"
    }

    ## Añade a un array todas las versiones de PHP encontradas en /etc/php
    local ALL_PHP=(`ls /etc/php/`)

    ## Configura todas las versiones de php existentes
    for V_PHP in "${ALL_PHP[@]}"; do
        #instalar_php "$V_PHP"
        configurar_php "$V_PHP"
        personalizar_php "$V_PHP"
        if [[ "$ENV" = 'dev' ]]; then
            xdebug "$V_PHP"
        fi
    done

    ## Si solo hay una versión de PHP la configura, en otro caso pregunta
    if [[ 1 = "${#ALL_PHP[@]}" ]]; then
        sudo a2enmod "php${ALL_PHP[0]}"
    else
        ## Pide introducir la versión de PHP para configurar con apache
        local salir=''

        while [[ $salir != 'salir' ]]; do
            clear_screen
            echo -e "$VE Introduce la versión de$RO PHP$VE a utilizar$CL"
            echo -e "$AZ ${ALL_PHP[*]} $RO"  ## Pinta versiones para elegirla
            read -p "    → " input
            for V_PHP in "${ALL_PHP[@]}"; do
                if [[ $input = "$V_PHP" ]]; then
                    sudo a2enmod "php$V_PHP"

                    ## Actualizo variables de entorno para la versión elegida.
                    sudo update-alternatives --set php "/usr/bin/php${V_PHP}"
                    sudo update-alternatives --set phar "/usr/bin/phar${V_PHP}"
                    sudo update-alternatives --set phar.phar "/usr/bin/phar.phar${V_PHP}"

                    salir='salir'
                    break
                fi
            done

            if [[ $salir = 'salir' ]]; then
                break
            fi

            echo -e "$AM No es válida la opción, introduce correctamente un valor$CL"
        done
    fi

    ## Activar módulos
    if [[ -f '/usr/sbin/phpenmod' ]] || [[ -f '/sbin/phpenmod' ]]; then
        echo -e "$VE Activando módulos$CL"
        sudo phpenmod 'fileinfo' 'ftp' 'curl' 'mongodb' 'pdo_pgsql' 'pgsql' 'sqlite3'

        if [[ "$ENV" = 'dev' ]]; then
            sudo phpenmod 'xdebug'
        fi

        echo -e "$VE Desactivando Módulos"
        ## Xdebug para PHP CLI no tiene sentido y ralentiza
        sudo phpdismod -s 'cli' 'xdebug'
    fi

    ## Reiniciar apache2 para hacer efectivos los cambios
    reiniciarServicio 'apache2'
}

php_instalador() {
    php_descargar
    php_preconfiguracion
    php_instalar
    php_postconfiguracion

    ## Instalo la última versión de composer
    php_composer_latest_install
}
