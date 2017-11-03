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
DIR_SCRIPT=`echo $PWD`

# Instalar versiones de Firefox
function firefox_install() {

    # Si no existen los directorios se crearán
    if [ ! -d ~/.local/opt ]
    then
        mkdir -p ~/.local/opt
    fi

    if [ ! -d ~/.local/bin ]
    then
        mkdir -p ~/.local/bin
    fi

    if [ ! -d ~/.local/share/applications ]
    then
        mkdir -p ~/.local/share/applications
    fi

    # Firefox Quantum Developer Edition
    function firefox_developer() {

        function instalar() {
            # Desempaquetar Firefox-Quantum_amd64.tar.bz2
            mkdir $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64 2>> /dev/null
            tar -xjvf $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64.tar.bz2 -C $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64 2>> /dev/null

            # Mover archivo extraido a su ubicación final
            mv $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64/firefox ~/.local/opt/Firefox_Quantum_Developer 2>> /dev/null

            # Desempaquetar Perfil y moverlo
            if [ ! -d ~/.mozilla/firefox/i5727yjx.Firefox-Quantum ]
            then
                mkdir $DIR_SCRIPT/Apps/Perfiles_Firefox/i5727yjx.Firefox-Quantum 2>> /dev/null
                tar -xJvf $DIR_SCRIPT/Apps/Perfiles_Firefox/i5727yjx.Firefox-Quantum.tar.xz -C $DIR_SCRIPT/Apps/Perfiles_Firefox/i5727yjx.Firefox-Quantum 2>> /dev/null
                mv $DIR_SCRIPT/Apps/Perfiles_Firefox/i5727yjx.Firefox-Quantum/* ~/.mozilla/firefox/ 2>> /dev/null
            fi

            # Crear enlaces de usuario y permisos de ejecución
            ln -s ~/.local/opt/Firefox_Quantum_Developer/firefox ~/.local/bin/firefox-quantum 2>> /dev/null
            chmod +x ~/.local/bin/firefox-quantum

            # Copiar acceso directo
            cp Accesos_Directos/firefox-quantum.desktop ~/.local/share/applications/ 2>> /dev/null

            # Pedir crear perfil
            # echo -e "$verde Para evitar conflictos entre distintas versiones crea un perfil"
            # echo -e "$verde Al pulsar una tecla se abrirá una ventana para ello"
            # echo -e "$verde El nombre convendrá que sea lógico como →$rojo Firefox-Quantum$amarillo"
            # read -p "Pulsa una tecla para abrir el ProfileManager" x
            # ~/.local/bin/firefox-quantum --ProfileManager
        }


        if [ -f ~/.local/bin/firefox-quantum ]
        then
            echo -e "$verde Ya esta$rojo Firefox Quantum Developer Edition$verde instalado en el equipo, omitiendo paso$gris"
        # Comprueba que no está el archivo descargado en este directorio
    elif [ ! -f $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64.tar.bz2 ]
        then
            REINTENTOS=50 actualizados, 0 nuevos se instalarán, 0 para eliminar y 4
            echo -e "$verde Descargando$rojo Firefox Quantum Developer Edition$gris"
            for (( i=1; i<=$REINTENTOS; i++ ))
            do
                rm $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64.tar.bz 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=es-ES' -O $DIR_SCRIPT/TMP/Firefox-Quantum-Developer_amd64.tar.bz2 && break
            done
            echo -e "$verde Preparando para instalar$rojo Firefox Quantum Developer Edition$gris"

            instalar
        else
            instalar
        fi
    }

    # Firefox Nightly
    function firefox_nightly() {

        function instalar() {
             # Desempaquetar Firefox-Nightly_amd64.tar.bz2
            mkdir $DIR_SCRIPT/TMP/Firefox-Nightly_amd64 2>> /dev/null
            tar -xjvf $DIR_SCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 -C $DIR_SCRIPT/TMP/Firefox-Nightly_amd64 2>> /dev/null

            # Mover archivo extraido a su ubicación final
            mv $DIR_SCRIPT/TMP/Firefox-Nightly_amd64/firefox ~/.local/opt/Firefox_Nightly 2>> /dev/null

            # Desempaquetar Perfil y moverlo
            if [ ! -d ~/.mozilla/firefox/fw493le3.Firefox-Nightly ]
            then
                mkdir $DIR_SCRIPT/Apps/Perfiles_Firefox/fw493le3.Firefox-Nightly 2>> /dev/null
                tar -xJvf $DIR_SCRIPT/Apps/Perfiles_Firefox/fw493le3.Firefox-Nightly.tar.xz -C $DIR_SCRIPT/Apps/Perfiles_Firefox/fw493le3.Firefox-Nightly 2>> /dev/null
                mv $DIR_SCRIPT/Apps/Perfiles_Firefox/fw493le3.Firefox-Nightly/* ~/.mozilla/firefox 2>> /dev/null
            fi

            # Crear enlaces de usuario y permisos de ejecución
            ln -s ~/.local/opt/Firefox_Nightly/firefox ~/.local/bin/firefox-nightly 2>> /dev/null
            chmod +x ~/.local/bin/firefox-nightly 2>> /dev/null

            # Copiar acceso directo
            cp -R Accesos_Directos/firefox-nightly.desktop ~/.local/share/applications/

            # Pedir crear perfil
            # echo -e "$verde Para evitar conflictos entre distintas versiones crea un perfil"
            # echo -e "$verde Al pulsar una tecla se abrirá una ventana para ello"
            # echo -e "$verde El nombre convendrá que sea lógico como →$rojo Firefox-Nightly$amarillo"
            # read -p "Pulsa una tecla para abrir el ProfileManager" x
            # ~/.local/bin/firefox-nightly --ProfileManager
        }


        if [ -f ~/.local/bin/firefox-nightly ]
        then
            echo -e "$verde Ya esta$rojo Firefox Nightly$verde instalado en el equipo, omitiendo paso$gris"
        elif [ ! -f $DIR_SCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 ]
        then
            REINTENTOS=3
            echo -e "$verde Descargando$rojo Firefox Nightly$gris"
            for (( i=1; i<=$REINTENTOS; i++ ))
            do
                rm $DIR_SCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 2>> /dev/null
                wget --show-progress -r -A tar.bz2 'https://download.mozilla.org/?product=firefox-nightly-latest-l10n-ssl&os=linux64&lang=es-ES' -O $DIR_SCRIPT/TMP/Firefox-Nightly_amd64.tar.bz2 && break
            done
            echo -e "$verde Preparando para instalar$rojo Firefox Nightly$gris"

            instalar
        else
            instalar
        fi
    }

    # Instalar Versiones de Firefox
    firefox_developer
    firefox_nightly
}
