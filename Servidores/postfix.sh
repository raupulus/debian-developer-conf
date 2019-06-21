#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
## Instala un servidor postfix + dovecot
## Usuario: postfix
## Grupo: postfix

############################
##        FUNCIONES       ##
############################

postfix_descargar() {
    echo -e "$VE Descargando$RO postfix$CL"
}

postfix_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO postfix"
    sudo apt purge -y exim4 exim4-base exim4-config
}

postfix_instalar() {
    echo -e "$VE Instalando$RO postfix$CL"
    instalarSoftwareLista "${SOFTLIST}/Servidores/postfix.lst"
}

postfix_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de postfix$CL"

    local dominio=''
    local postfixconf='/etc/postfix/main.cf'
    local dovecotconf='/etc/dovecot/conf.d/10-auth.conf'

    echo -e "$VE Introduce el dominio$RO mail$VE por ejemplo$AM mail.miweb.es$CL"
    echo -e "$VE Deja en blanco para continuar sin configurar$CL"
    read -p '  → ' input

    if [[ $input = '' ]]; then
        ## Configuración Postfix
        sudo sed -r -i "s/^#?\s*mydomain =/$dominio/" "$postfixconf"
        sudo sed -r -i "s/^#?\s*myhostname =/$dominio/" "$postfixconf"

        ## Configuración Dovecot
        sudo sed -r -i "s/^#?\s*disable_plaintext_auth =/disable_plaintext_auth = no/" "$dovecotconf"
        echo "localhost $dominio" | sudo tee -a /etc/hosts

        ## Reconfigurar postfix y comprobar datos
        sudo dpkg-reconfigure postfix
    fi
}

postfix_instalador() {
    postfix_descargar
    postfix_preconfiguracion
    postfix_instalar

    ## Reiniciar servidor postfix para aplicar configuración
    reiniciarServicio postfix
    reiniciarServicio dovecot
}
