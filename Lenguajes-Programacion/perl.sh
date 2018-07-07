#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
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

perl_descargar() {
    echo -e "$VE Descargando$RO Perl$CL"
}

perl_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Perl$CL"
}

perl_instalar() {
    echo -e "$VE Instalando$RO C$VE y$RO C++$CL"
    instalarSoftware 'perl perl-base'

    echo -e "$VE Instalando paquetes complementarios de$RO Perl$CL"
    local complementarios='perl-openssl-defaults perl-depends'
    instalarSoftware "$complementarios"
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
