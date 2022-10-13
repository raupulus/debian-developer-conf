#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-style-guide

############################
##      INSTRUCTIONS      ##
############################
## Prepara un VPS recién creado antes de ejecutar el script principal.
## Este script debe ejecutarse como root.

## Importo variables globales para evitar conflictos de configuración sin reboot
if [[ -f '/etc/environment' ]]; then
    source '/etc/environment'
fi

DEBUG='false'      ## Establece si está el script en modo depuración
WORKSCRIPT=$PWD  ## Directorio principal del script

## Importo variables locales si existieran, sobreescriben a las globales
if [[ -a "$WORKSCRIPT/.env" ]]; then
    source "$WORKSCRIPT/.env"
fi

###########################
##       FUNCIONES       ##
###########################

if [[ $USER != 'root' ]]; then
    echo 'Este script tiene que ser iniciado por root'
    exit 1
fi

if [[ ! -f '/usr/bin/git' ]]; then
    echo 'Se necesita tener instalado "git"'
    echo 'Prueba con tu gestor de paquetes, por ejemplo: apt install git'
    exit 1
fi

if [[ ! -f '/usr/bin/wget' ]]; then
    echo 'Se necesita tener instalado "wget"'
    echo 'Prueba con tu gestor de paquetes, por ejemplo: apt install wget'
    exit 1
fi

read -p "    Nombre del usuario principal → " username

#TODO → Asegurar que no pasa en blanco, comprobar mejor esta parte y volver a pedir
if [[ "$username" = '' ]] && [[ "$username" = ' ' ]]; then
    username='admin'
fi

adduser $username
gpasswd -a $username sudo
gpasswd -a $username crontab
gpasswd -a $username $username
gpasswd -a $username go
gpasswd -a $username www-data

if [[ ! -d "/home/${username}/debian-developer-conf" ]]; then
    git clone https://gitlab.com/fryntiz/debian-developer-conf.git \
    "/home/${username}/debian-developer-conf"
fi

chown "$username:$username" -R "/home/$username/debian-developer-conf"
chmod 755 -R "/home/${username}/debian-developer-conf"
cd "/home/$username/debian-developer-conf" || exit

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

su $username ./main.sh

exit 0
