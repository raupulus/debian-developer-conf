#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Menú principal para instalar y configurar Lenguajes de Programación
## elegir entre cada uno de ellos desde un menú o todos directamente
## en un proceso automatizado.

############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/Lenguajes-Programacion/c.sh"
source "$WORKSCRIPT/Lenguajes-Programacion/go.sh"
source "$WORKSCRIPT/Lenguajes-Programacion/php.sh"
source "$WORKSCRIPT/Lenguajes-Programacion/python.sh"
source "$WORKSCRIPT/Lenguajes-Programacion/ruby.sh"
source "$WORKSCRIPT/Lenguajes-Programacion/perl.sh"
source "$WORKSCRIPT/Lenguajes-Programacion/android.sh"

###########################
##       FUNCIONES       ##
###########################
##
## Menú para elegir los lenguajes de programación a instalar y configurar
## @param $1 -a Si recibe este parámetro ejecutará todos los scripts
##
menuLenguajes() {
    todos_lenguajes() {
        clear_screen
        echo -e "$VE Instalando todos los lenguajes$CL"
        php_instalador "$1"
        python_instalador "$1"

        if [[ "$1" != 'prod' ]]; then
            ruby_instalador
            go_instalador
            c_instalador
            perl_instalador
            android_instalador
        fi
    }

    if [[ "$1" = '-a' ]]; then
        if [[ "$2" = 'prod' ]]; then
            todos_lenguajes 'prod'
        else
            todos_lenguajes
        fi
    else
        while true :; do
            clear_screen
            local descripcion='Menú Lenguajes de programación
                1) PHP
                2) Python
                3) Ruby
                4) Go
                5) C y C++
                6) Perl
                7) Android
                8) Todos los pasos anteriores

                0) Atrás
            '
            opciones "$descripcion"

            echo -e "$RO"
            read -p "    Acción → " entrada
            echo -e "$CL"

            case $entrada in

                1)  php_instalador;;         ## Instala PHP
                2)  python_instalador;;      ## Instala Python
                3)  ruby_instalador;;        ## Instala Ruby
                4)  go_instalador;;          ## Instala Go
                5)  c_instalador;;           ## Instala C y C++
                6)  perl_instalador;;        ## Instala C y C++
                7)  android_instalador;;     ## Instala Android
                8)  todos_lenguajes          ## Todos los lenguajes
                    break;;

                0)  ## SALIR
                    clear_screen
                    echo -e "$RO Se sale del menú$CL"
                    echo ''
                    break;;

                *)  ## Acción ante entrada no válida
                    echo ""
                    echo -e "             $RO ATENCIÓN: Elección no válida$CL";;
            esac
        done
    fi
}
