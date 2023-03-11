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
## Este script instala siempre las aplicaciones que considero básicas en un
## sistema operativo para trabajar y desarrollar.
##
## La lista de software utilizada se extrae de "Software.lst" y cualquier
## progama que añadamos en este archivo, será instalado desde este script.

###########################
##       FUNCIONES       ##
###########################
aplicaciones_basicas() {
    echo -e "$VE Instalando aplicaciones básicas$CL"
    actualizarRepositorios

    repararGestorPaquetes

    instalarSoftwareLista "$SOFTLIST/Basico/audio.lst"
    instalarSoftwareLista "$SOFTLIST/Basico/compresores.lst"
    instalarSoftwareLista "$SOFTLIST/Basico/firewall.lst"
    instalarSoftwareLista "$SOFTLIST/Basico/herramientas.lst"
    instalarSoftwareLista "$SOFTLIST/Basico/internet.lst"
    instalarSoftwareLista "$SOFTLIST/Basico/monitores.lst"
    instalarSoftwareLista "$SOFTLIST/Basico/terminal.lst"
    instalarSoftwareLista "$SOFTLIST/Basico/tipografias.lst"
    instalarSoftwareLista "$SOFTLIST/Basico/network.lst"

    repararGestorPaquetes
}
