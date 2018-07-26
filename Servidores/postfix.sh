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
    local software='postfix dovecot-imapd dovecot-pop3d dovecot-common bsd-mailx'
    instalarSoftware "$software"
}

postfix_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de postfix$CL"

    local dominio=''

    ## Configuración, se guardará en /etc/postfix/main.cf
    ## Sitio de internet
    ## Nombre del sistema de correo: fryntiz.cloud

    ## Pedir entrada de datos para esta parte
    #sudo nano /etc/postfix/main.cf
    ## mydomain = mail.fryntiz.cloud
    ## myhostname = mail.fryntiz.cloud


    ## Configurar dovecot
    #sudo nano /etc/dovecot/conf.d/10-auth.conf
    ## disable_plaintext_auth = no

    ## Agregar dominios admitidos a /etc/hosts
    echo "localhost $dominio" | sudo tee -a /etc/hosts

    ## Reconfigurar postfix y comprobar datos
    sudo dpkg-reconfigure postfix
}

postfix_instalador() {
    postfix_descargar
    postfix_preconfiguracion
    postfix_instalar

    ## Reiniciar servidor postfix para aplicar configuración
    reiniciarServicio postfix
    reiniciarServicio dovecot
}
