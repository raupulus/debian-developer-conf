#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-style-guide

############################
##     INSTRUCCIONES      ##
############################
## Prepara un VPS recién creado antes de ejecutar el script principal.
## Este script debe ejecutarse como root.

###########################
##       FUNCIONES       ##
###########################

if [[ $USER != 'root' ]]; then
    echo 'Este script tiene que ser iniciado por root'
    exit 1
fi

apt install sudo git
adduser web
gpasswd -a web sudo
gpasswd -a web crontab
gpasswd -a web web
gpasswd -a web www-data

if [[ ! -d /home/web/debian-developer-conf ]]; then
    git clone https://gitlab.com/fryntiz/debian-developer-conf.git \
    /home/web/debian-developer-conf
fi

chown web:web -R /home/web/debian-developer-conf
cd /home/web/debian-developer-conf || exit

## TODO → Con el "all" ya es suficiente, pero es necesario comprobar que exista
## la línea ya que al volver a ejecutar script o en algunos servidores ya se
## encuentra y produce problemas después con firewalld u otros cortafuegos.

# Desactivar ipv6 por completo
echo 'net.ipv6.conf.all.disable_ipv6=1' >> '/etc/sysctl.conf'
echo 'net.ipv6.conf.default.disable_ipv6=1' >> '/etc/sysctl.conf'
echo 'net.ipv6.conf.lo.disable_ipv6=1' >> '/etc/sysctl.conf'
echo 'net.ipv6.conf.eth0.disable_ipv6=1' >> '/etc/sysctl.conf'
sysctl -p

# Desactivar ipv6 temporalmente en el momento
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1

sudo -u web ./main.sh

exit 0
