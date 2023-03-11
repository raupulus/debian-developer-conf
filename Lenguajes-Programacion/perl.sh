#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

perl_descargar() {
    echo -e "$VE Descargando$RO Perl$CL"
}

perl_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Perl$CL"
}

perl_instalar() {
    echo -e "$VE Instalando$RO Perl$CL"

    instalarSoftwareLista "$SOFTLIST/Lenguajes-Programacion/perl.lst"
}

perl_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO Perl$CL"
}

perl_instalador() {
    perl_descargar
    perl_preconfiguracion
    perl_instalar
    perl_postconfiguracion
}
