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
##        FUNCIONES       ##
############################

php_descargar() {
    echo "$VE Descargando$RO php$CL"
}

php_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO php"
}

php_instalar() {
    echo -e "$VE Instalando$RO php$CL"
    local paquetes_basicos="php php-cli libapache2-mod-php"
    instalarSoftware "$paquetes_basicos"

    echo -e "$VE Instalando$RO paquetes extras$CL"
    ## TODO → Convertir en array el contenido de la variable:
    local paquetes_extras="php-gd php-curl php-pgsql php-sqlite3 sqlite sqlite3 php-intl php-mbstring php-xml php-xdebug php-json"
    instalarSoftware "$paquetes_extras"

    echo -e "$VE Instalando librerías$CL"
    instalarSoftware composer
}

php_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de php"

    ##
    ## Recibe la versión de PHP para configurar y modifica sus archivos
    ## @param $1 Es la versión de php dentro de /etc/php
    ##
    configurar_php() {
        echo -e "$VE Preparando configuracion de$RO PHP$CL"
        local PHPINI="/etc/php/$1/apache2/php.ini"  # Ruta al archivo de configuración de PHP con apache2

        ## Modificar configuración
        echo -e "$VE Estableciendo zona horaria por defecto para PHP$CL"
        sudo sed -r -i "s/^;?\s*date\.timezone\s*=.*$/date\.timezone = 'UTC'/" $PHPINI

        echo -e "$VE Activando Reportar todos los errores → 'error_reporting'$CL"
        sudo sed -r -i "s/^;?\s*error_reporting\s*=.*$/error_reporting = E_ALL/" $PHPINI

        echo -e "$VE Activando Mostrar errores → 'display_errors'$CL"
        sudo sed -r -i "s/^;?\s*display_errors\s*=.*$/display_errors = On/" $PHPINI

        echo -e "$VE Activando Mostrar errores al iniciar → 'display_startup_errors'$CL"
        sudo sed -r -i "s/^;?\s*display_startup_errors\s*=.*$/display_startup_errors = On/" $PHPINI
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
        instalar_php "$V_PHP"
        configurar_php "$V_PHP"
        personalizar_php "$V_PHP"
        xdebug "$V_PHP"
    done

    ## Si solo hay una versión de PHP la configura, en otro caso pregunta
    if [[ 1 = ${#ALL_PHP[@]} ]]; then
        sudo a2enmod "php${ALL_PHP[0]}"
    else
        ## Pide introducir la versión de PHP para configurar con apache
        while true :; do
            clear
            echo -e "$VE Introduce la versión de$RO PHP$VE a utilizar$CL"
            echo -e "$AZ ${ALL_PHP[@]} $RO"  ## Pinta versiones para elegirla
            read -p "    → " input
            for V_PHP in "${ALL_PHP[@]}"; do
                if [[ $input = $V_PHP ]]; then
                    sudo a2enmod "php$V_PHP"
                    break
                fi
            done
            echo -e "AM No es válida la opción, introduce correctamente un valor$CL"
        done
    fi

    ## Activar módulos
    echo -e "$VE Activando módulos$CL"
    sudo phpenmod -s apache2 xdebug

    echo -e "$VE Desactivando Módulos"
    ## Xdebug para PHP CLI no tiene sentido y ralentiza
    sudo phpdismod -s cli xdebug

    ## Reiniciar apache2 para hacer efectivos los cambios
    reiniciarServicio apache2
}


php_instalador() {
    php_descargar
    php_preconfiguracion
    php_instalar
    php_postconfiguracion
}
