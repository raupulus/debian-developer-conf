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
software=$(cat Software.lst) #Instala software del S.O.

# Recorrer "Software.lst" Instalando paquetes ahí descritos
function instalar_Software() {
    # Actualizar LIstas
    echo -e "$verde Actualizando listas de$rojo Repositorios$verde (Paciencia)$gris"
    sudo apt update >> /dev/null 2>> /dev/null

    # Repara errores de dependencias rotas que pudiesen haber
    echo -e "$verde Comprobando estado del$rojo Gestor de paquetes$verde (Paciencia)$gris"
    sudo apt --fix-broken install -y >> /dev/null 2>> /dev/null
    sudo apt install -f -y >> /dev/null 2>> /dev/null

    # Instalando todo el software desde "Software.lst
    echo -e "$verde Instalando Software adicional$gris"
    # La siguiente variable guarda toda la lista de paquetes desde DPKG
    lista_todos_paquetes=${dpkg-query -W -f='${Installed-Size} ${Package}\n' | sort -n | cut -d" " -f2}

    # Comprueba si el software está instalado y en caso contrario instala
    for s in $software
    do
        tmp=true  # Comprueba si necesita instalarse (true)

        for x in $lista_todos_paquetes
        do
            if [ $s == $x ]
            then
                echo -e "$rojo $s$verde ya estaba instalado"
                tmp=false
                break
            fi
        done

        if [ $tmp == "true" ]
        then
            sudo apt install -y $s >> /dev/null 2>> /dev/null && echo -e "$rojo $s$verde instalado correctamente" || echo -e "$rojo $s$amarillo No se ha instalado (o no existe con este nombre)$gris"
        fi
    done

    sudo apt --fix-broken install 2>> /dev/null
    sudo apt install -f -y 2>> /dev/null
}
