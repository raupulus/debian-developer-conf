#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Descarga e instala ninja IDE (Editor para python) resolviendo libreías y
## dependencias que faltan.

############################
##       FUNCIONES        ##
############################
ninjaide_descargar() {
    ##descargar 'ninja-ide.deb' 'http://ftp.es.debian.org/debian/pool/main/n/ninja-ide/ninja-ide_2.3-2_all.deb'
    descargar 'ninja-ide.deb' 'https://github.com/ninja-ide/ninja-ide/releases/download/v2.4/ninja-ide-2.4.deb'
}

ninjaide_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones"
    enlazarHome '.ninja_ide'
}

ninjaide_instalar() {
    echo -e "$VE Preparando para instalar$RO Ninja IDE$CL"
    instalarSoftware python-qt4 >> /dev/null 2>> /dev/null && echo -e "$VE Se ha instalado$RO python-qt4$CL" || echo -e "$VE No se ha instalado$RO python-qt4$CL"
    instalarSoftwareDPKG "$WORKSCRIPT/tmp/ninja-ide.deb"
}

ninjaide_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones"

    ## Resolviendo dependencia de libreria QtWebKit.so si no existe
    instalarSoftware 'libqtwebkit4' 2>> /dev/null
    if [[ ! -f '/usr/lib/python2.7/dist-packages/PyQt4/QtWebKit.so' ]]; then
        echo -e "$VE Añadiendo libreria$RO QtWebKit$CL"
        sudo mkdir -p '/usr/lib/python2.7/dist-packages/PyQt4/' 2>> /dev/null
        sudo cp "$WORKSCRIPT/conf/usr/lib/python2.7/dist-packages/PyQt4/QtWebKit.so" '/usr/lib/python2.7/dist-packages/PyQt4/'
    fi

    ## Resolviendo otras dependencia de plugins para Ninja IDE
    echo -e "$VE Resolviendo$RO dependencias$VE para plugins de Ninja IDE$CL"
    instalarSoftware 'python-git' 'python3-git'
}

## Instala el editor de python Ninja IDE
ninjaide_instalador() {
    ninjaide_preconfiguracion

    if [[ -f '/usr/bin/ninja-ide' ]]; then
        echo -e "$VE Ya esta$RO Ninja IDE$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/ninja-ide.deb" ]]; then
            ninjaide_instalar
        else
            ninjaide_descargar
            ninjaide_instalar
        fi

        ## Si falla la instalación se rellama la función tras limpiar
        if [[ ! -f '/usr/bin/ninja-ide' ]]; then
            rm -f "$WORKSCRIPT/tmp/ninja-ide.deb"
            ninjaide_descargar
            ninjaide_instalar
        fi
    fi

    ninjaide_postconfiguracion
}
