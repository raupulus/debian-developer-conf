#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-style-guide

############################
##      INSTRUCTIONS      ##
############################
## Instala php en su última versión estable desde repositorios y además
## configura todas las versiones instaladas en el sistema.
## Se activan módulos necesarios de apache y se corrigen posibles conflictos
## con otras versiones en archivos de configuración si hemos actualizado desde
## php 5.
## Configura Xdebug también.

############################
##        FUNCTIONS       ##
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

##
## Recibe la ruta del phpini en modo desarrollo y lo configura.
## @param $1 La ruta hacia el phpini a configurar.
php_parse_phpini_dev() {
    local PHPINI=$1

    if [[ ! -f $PHPINI ]]; then
        return
    fi

    ## TOFIX: Esta línea da error "sed: 1: "s/^#?[[:space:]]*LoadMo ...": bad flag in substitute command: 'o'"
    strFileReplace 's/^#?[[:space:]]*LoadModule php8_module.*$/LoadModule php8_module /opt/homebrew/Cellar/php@8.0/8.0.21/lib/httpd/modules/libphp.so/g' $PHPINI


    echo -e "$VE Estableciendo zona horaria por defecto para PHP$CL"
    strFileReplace 's/^;?[[:space:]]*date\.timezone[[:space:]]*=.*$/date\.timezone = "UTC"/g' $PHPINI
    #sudo sed -r -i '' "s/^;?\s*date\.timezone\s*=.*$/date\.timezone = 'UTC'/" $PHPINI

    echo -e "$VE Configurando PHP para desarrollo$CL"
    echo -e "$VE Activando Reportar todos los errores → 'error_reporting'$CL"
    strFileReplace 's/^;?[[:space:]]*error_reporting[[:space:]]*=.*$/error_reporting = E_ALL/g' $PHPINI
    #sudo sed -r -i '' "s/^;?\s*error_reporting\s*=.*$/error_reporting = E_ALL/" $PHPINI

    echo -e "$VE Activando Mostrar errores → 'display_errors'$CL"
    strFileReplace 's/^;?[[:space:]]*display_errors[[:space:]]*=.*$/display_errors = On/g' $PHPINI
    #sudo sed -r -i '' "s/^;?\s*display_errors\s*=.*$/display_errors = On/" $PHPINI

    echo -e "$VE Activando Mostrar errores al iniciar → 'display_startup_errors'$CL"
    strFileReplace 's/^;?[[:space:]]*display_startup_errors[[:space:]]*=.*$/display_startup_errors = On/g' $PHPINI
    #sudo sed -r -i '' "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = On/" $PHPINI

    echo -e "$VE Tiempo máximo de ejecución 5 minutos → 'max_execution_time'$CL"
    strFileReplace 's/^;?[[:space:]]*max_execution_time[[:space:]]*=.*$/max_execution_time = 60/g' $PHPINI
    #sudo sed -r -i '' "s/^;?\s*max_execution_time\s*=.*$/max_execution_time = 300/" $PHPINI

    echo -e "$VE Límite de Memoria por script → 'memory_limit = 512M'$CL"
    strFileReplace 's/^;?[[:space:]]*memory_limit[[:space:]]*=.*$/memory_limit = 512M/g' $PHPINI
    #sudo sed -r -i '' "s/^;?\s*memory_limit\s*=.*$/memory_limit = 512M/" $PHPINI

    ## Límite de archivos
    echo -e "$VE Tamaño máximo de subida → 'upload_max_filesize = 10240M'$CL"
    strFileReplace 's/^;?[[:space:]]*upload_max_filesize[[:space:]]*=.*$/upload_max_filesize = 10240M/g' $PHPINI
    #sudo sed -r -i '' "s/^;?\s*upload_max_filesize\s*=.*$/upload_max_filesize = 10240M/" $PHPINI

    echo -e "$VE Tamaño máximo de POST → 'post_max_size = 10240M'$CL"
    strFileReplace 's/^;?[[:space:]]*post_max_size[[:space:]]*=.*$/post_max_size = 10240M/g' $PHPINI
    #sudo sed -r -i '' "s/^;?\s*post_max_size\s*=.*$/post_max_size = 10240M/" $PHPINI

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
            return
        fi

        ## Modificar configuración
        echo -e "$VE Estableciendo zona horaria por defecto para PHP$CL"
        sudo sed -r -i "s/^;?[[:space:]]*date\.timezone[[:space:]]*=.*$/date\.timezone = 'UTC'/" $PHPINI

        ## Configuración para desarrollo
        if [[ "$ENV" = 'dev' ]]; then
            php_parse_phpini_dev $PHPINI
        else
            echo -e "$VE Configurando PHP para producción$CL"
            echo -e "$VE Desactivando Reportar todos los errores → 'error_reporting'$CL"
            sudo sed -r -i "s/^;?\s*error_reporting\s*=.*$/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/" $PHPINI

            echo -e "$VE Desactivando Mostrar errores → 'display_errors'$CL"
            sudo sed -r -i "s/^;?\s*display_errors\s*=.*$/display_errors = Off/" $PHPINI

            echo -e "$VE Desactivando Mostrar errores al iniciar → 'display_startup_errors'$CL"
            sudo sed -r -i "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = Off/" $PHPINI

            echo -e "$VE Tiempo máximo de ejecución 5 minutos → 'max_execution_time'$CL"
            sudo sed -r -i "s/^;?\s*max_execution_time\s*=.*$/max_execution_time = 120/" $PHPINI

            echo -e "$VE Límite de Memoria por script → 'memory_limit = 128M'$CL"
            sudo sed -r -i "s/^;?\s*memory_limit\s*=.*$/memory_limit = 128M/" $PHPINI

            ## Límite de archivos
            echo -e "$VE Tamaño máximo de subida → 'upload_max_filesize = 1024M'$CL"
            sudo sed -r -i "s/^;?\s*upload_max_filesize\s*=.*$/upload_max_filesize = 1024M/" $PHPINI

            echo -e "$VE Tamaño máximo de POST → 'post_max_size = 1024M'$CL"
            sudo sed -r -i "s/^;?\s*post_max_size\s*=.*$/post_max_size = 1024M/" $PHPINI
        fi
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

    if [[ $DISTRO = 'macos' ]];then
        ALL_PHP=(`ls /opt/homebrew/etc/php`)
    fi

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

php_macos_installer() {
    php_descargar
    php_preconfiguracion
    php_instalar

    brew services stop php@8.1 2> /dev/null
    brew services start php@8.0
    brew services start php@7.3

    # TODO: Configurar xdebug
    # TODO: configurar todos los php.ini, refactorizar función para ENV=dev

    ## Fuerzo cambiar dos veces, la primera vez parece que crea php.ini en
    ## versiones obsoletas que vienen de otros paquetes, como la 7.3
    #$(brew --prefix php@7.3)/bin/pecl
    #$(brew --prefix php@7.3)/bin/pear
    #brew unlink php && brew link --overwrite --force php@7.3
    pecl clear-cache
    rm -Rf /private/tmp/pear/cache/*
    rm -Rf /private/tmp/pear/download/*
    rm -Rf /private/tmp/pear/temp/*

    pecl update-channels
    brew unlink php && brew unlink php@7.3 && brew link php@7.3 --dry-run && brew link --overwrite --force php@7.3
    pecl install pecl_http


    pecl clear-cache
    rm -Rf /private/tmp/pear/cache/*
    rm -Rf /private/tmp/pear/download/*
    rm -Rf /private/tmp/pear/temp/*

    #/opt/homebrew/opt/zlib/lib
    #/opt/homebrew/Cellar/curl/7.84.0/lib
    #/opt/homebrew/Cellar/curl/7.84.0/lib
    #/opt/homebrew/var/homebrew/linked/libevent/lib
    #/opt/homebrew/Cellar/icu4c/70.1/lib
    #/opt/homebrew/var/homebrew/linked/libidn2/lib
    #/opt/homebrew/var/homebrew/linked/libidn/lib
    #libidnkit2   ????
    #libidnkit   ????
    #pecl install pecl_http --with-zlib-dir=/usr/local/Cellar/zlib/1.2.11/include
    #brew unlink php && brew link --overwrite --force php@8.0
    brew unlink php && brew unlink php@8.0 && brew link php@8.0 --dry-run && brew link --overwrite --force php@8.0
    #pecl update-channels
    #pecl install pecl_http

    php_parse_phpini_dev '/opt/homebrew/etc/php/7.3/php.ini'
    php_parse_phpini_dev '/opt/homebrew/etc/php/8.0/php.ini'
}

php_instalador() {
    if [[ $DISTRO = 'macos' ]];then
        php_macos_installer
        return
    fi

    php_descargar
    php_preconfiguracion
    php_instalar
    php_postconfiguracion

    ## Instalo la última versión de composer
    php_composer_latest_install
}
