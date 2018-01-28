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
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################

############################
##     IMPORTACIONES      ##
############################

############################
##       CONSTANTES       ##
############################

###########################
##       VARIABLES       ##
###########################

###########################
##       FUNCIONES       ##
###########################
aplicaciones_basicas() {
    echo -e "$VE Instalando aplicaciones básicas$CL"
    ## Actualizar Listas
    echo -e "$VE Actualizando listas de$RO Repositorios$VE (Paciencia)$CL"
    sudo apt update >> /dev/null 2>> /dev/null

    ## Repara errores de dependencias rotas que pudiesen haber
    echo -e "$VE Comprobando estado del$RO Gestor de paquetes$VE (Paciencia)$CL"
    sudo apt --fix-broken install -y >> /dev/null 2>> /dev/null
    sudo apt install -f -y >> /dev/null 2>> /dev/null

    ## Instalando todo el software desde "Software.lst
    echo -e "$VE Instalando Software adicional$CL"
    ## La siguiente variable guarda toda la lista de paquetes desde DPKG
    local lista_todos_paquetes=(${dpkg-query -W -f='${Installed-Size} ${Package}\n' | sort -n | cut -d" " -f2})

    ## Comprueba si el software está instalado y en caso contrario instala
    local lista_Software=(`cat $WORKSCRIPT/Software.lst`)
    for s in "${lista_Software[@]}"; do
        for x in "${lista_todos_paquetes[@]}"; do
            if [[ $s = $x ]]; then
                echo -e "$RO $s$VE ya estaba instalado$CL"
                tmp=false
                break
            else
                instalarSoftware "$s"
                break
            fi
        done
    done

    sudo apt --fix-broken install 2>> /dev/null
    sudo apt install -f -y 2>> /dev/null
}

###########################
##       EJECUCIÓN       ##
###########################
