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

nodejs_descargar() {
    echo -e "$VE Descargando$RO NodeJS$CL"
}

nodejs_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO NodeJS$CL"
}

nodejs_instalar() {
    echo -e "$VE Instalando$RO NodeJS$CL"
    instalarSoftware nodejs
    actualizarSoftware nodejs
}

nodejs_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de NodeJS$CL"

    ## Instalando paquetes globales
    ## TODO → Crear función general para instalar paquetes con npm
    sudo npm install -g eslint
    sudo npm install -g jscs
    sudo npm install -g bower
    sudo npm install -g compass
    sudo npm install -g stylelint
    sudo npm install -g bundled
}


nodejs_instalador() {
    nodejs_descargar
    nodejs_preconfiguracion
    nodejs_instalar
    nodejs_postconfiguracion
}



server_nodejs() {


    personalizar_nodejs() {
        echo -e "$VE Personalizando$RO NodeJS$CL"
        ## Instalando paquetes globales
        sudo npm install -g eslint
        sudo npm install -g jscs
        sudo npm install -g bower
        sudo npm install -g compass
        sudo npm install -g stylelint
        sudo npm install -g bundled
    }

    instalar_nodejs
    configurar_nodejs
    personalizar_nodejs
}
