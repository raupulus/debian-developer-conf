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
## Instala el Editor/IDE Brackets en el sistema resolviendo dependencias y
## descargándolo desde su sitio oficial.

############################
##       FUNCIONES        ##
############################

brackets_descargar() {
    descargar 'Brackets.deb' "https://github.com/adobe/brackets/releases/download/release-1.13/Brackets.Release.1.13.64-bit.deb"

    descargar 'libgcrypt.deb' "http://security.debian.org/debian-security/pool/updates/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u6_amd64.deb"
}

brackets_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Brackets$CL"
}

brackets_instalar() {
    echo -e "$VE Preparando para instalar$RO Brackets$CL"
    sudo dpkg -i "$WORKSCRIPT/tmp/libgcrypt.deb"

    echo -e "$VE Instalando$RO Brackets$CL"
    sudo dpkg -i "$WORKSCRIPT/tmp/Brackets.deb" && sudo apt install -f -y
}

brackets_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones$RO Brackets$CL"

    echo -e "$VE Generando acceso directo$CL"
    cp "$WORKSCRIPT/Accesos_Directos/brackets.desktop" "$HOME/.local/share/applications/"
}

brackets_instalador() {
    echo -e "$VE Comenzando instalación de$RO Brackets$CL"

    brackets_preconfiguracion

    if [[ -f '/usr/bin/brackets' ]]; then
        echo -e "$VE Ya esta$RO Brackets$VE instalado en el equipo, omitiendo paso$CL"
    else
        if [[ -f "$WORKSCRIPT/tmp/Brackets.deb" ]]; then
            brackets_instalar
        else
            brackets_descargar
            brackets_instalar
        fi
    fi

    brackets_postconfiguracion
}
