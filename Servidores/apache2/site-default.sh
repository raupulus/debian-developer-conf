#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      dev@fryntiz.es
## @web        https://.fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://github.com/fryntiz/Bash_Style_Guide

############################
##     INSTRUCCIONES      ##
############################
## Agrega, configura y habilita el sitio por defecto con ssl.

############################
##        FUNCIONES       ##
############################
apacheDefaultSiteCreate() {
    local nombreSitio='default'
    local existe=$(apache2ExisteSitioVirtual "${nombreSitio}.conf" "$nombreSitio")

    if [[ $existe != 'true' ]]; then
        apache2AgregarDirectorio $nombreSitio
        apache2GenerarConfiguracion "${nombreSitio}.conf" "$nombreSitio"
    fi

}





## Deshabilita Sitios Virtuales (VirtualHost)
sudo a2dissite '000-default.conf'
sudo a2dissite 'default.conf'
sudo a2dissite 'default-ssl.conf'
sudo a2dissite 'publico.conf'
sudo a2dissite 'publico-ssl.conf'
sudo a2dissite 'privado.conf'
sudo a2dissite 'privado-ssl.conf'
sudo a2dissite 'dev.conf'
sudo a2dissite 'dev-ssl.conf'

## Habilita Sitios Virtuales (VirtualHost) para desarrollo
if [[ "$ENV" = 'dev' ]]; then
    sudo a2ensite 'default.conf'
    sudo a2ensite 'publico.conf'
    sudo a2ensite 'privado.conf'
    sudo a2ensite 'dev.conf'
fi

activar_hosts() {
    echo -e "$VE Añadiendo$RO Sitios Virtuales$AM"
    echo '127.0.0.1 privado' | sudo tee -a '/etc/hosts'
    echo '127.0.0.1 privado.local' | sudo tee -a '/etc/hosts'
    echo '127.0.0.1 publico' | sudo tee -a '/etc/hosts'
    echo '127.0.0.1 publico.local' | sudo tee -a '/etc/hosts'
    echo '127.0.0.1 dev' | sudo tee -a '/etc/hosts'
    echo '127.0.0.1 dev.local' | sudo tee -a '/etc/hosts'
}

read -p " ¿Quieres añadir sitios virtuales a /etc/hosts? s/N → " input
if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
    activar_hosts
else
    echo -e "$VE No se añade nada a$RO /etc/hosts$CL"
fi
