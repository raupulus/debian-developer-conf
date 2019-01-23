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
##
## Agrega configuraciones de seguridad y permisos para el sitio virtual.
##
apacheDefaultSiteSecurity() {
    ## Crear archivo de usuario con permisos para directorios restringidos
    echo -e "$VE Creando usuario con permisos en apache"
    sudo rm /var/www/.htpasswd 2>> /dev/null

    while [[ -z "$input_user" ]]; do
        read -p "Nombre de usuario para acceder al sitio web privado → " input_user
    done

    echo -e "$VE Introduce la contraseña para el sitio privado:$RO"
    sudo htpasswd -c /var/www/.htpasswd $input_user
}

apacheDefaultSiteCreate() {
    ## Todo → Mirar si existe el sitio


    apache2AgregarDirectorio 'default'
    apache2GenerarConfiguracion '??????'





    apacheDefaultSiteGenerateDir

    apacheDefaultSiteGenerateConf

    apacheDefaultSiteSecurity
}



clear
echo -e "$VE Personalizando$RO Apache2$CL"

echo -e "$VE Es posible generar una estructura dentro de /var/www"
echo -e "$VE Ten en cuenta que esto borrará el contenido actual"
echo -e "$VE También se modificarán archivos en /etc/apache2/*$RO"
read -p " ¿Quieres Generar la estructura y habilitarla? s/N → " input
if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
    apache2_generar_www
else
    echo -e "$VE No se genera la estructura predefinida y automática"
fi

## Generar enlaces (desde ~/web a /var/www)
enlaces() {
    clear
    echo -e "$VE Puedes generar un enlace en tu home ~/web hacia /var/www/html/Publico"
    read -p " ¿Quieres generar el enlace? s/N → " input
    if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
        sudo ln -s '/var/www/html/Publico' "/home/$USER/web"
        sudo chown -R "$USER:www-data" "/home/$USER/web"
    else
        echo -e "$VE No se crea enlace desde ~/web a /var/www/html/Publico"
    fi

    clear
    echo -e "$VE Puedes crear un directorio para repositorios$RO GIT$VE en tu directorio personal"
    echo -e "$VE Una vez creado se añadirá un enlace al servidor web"
    echo -e "$VE Este será desde el servidor /var/www/html/Privado/GIT a ~/GIT$RO"
    read -p " ¿Quieres crear el directorio y generar el enlace? s/N → " input
    if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
        if [[ ! -d "$HOME/GIT" ]]; then
            echo -e "$VE Creando directorio$RO $HOME/GIT$VE"
            mkdir "$HOME/GIT"
        fi

        ## Creando enlaces en el directorio Home
        if [[ ! -h '/var/www/html/Privado/GIT' ]]; then
            sudo ln -s "$HOME/GIT" '/var/www/html/Privado/GIT'
        fi

        if [[ ! -h "$HOME/git" ]] && [[ -h "$HOME/GIT" ]]; then
            sudo ln -s "$HOME/GIT" "$HOME/git"
        fi
    else
        echo -e "$VE No se crea enlaces ni directorio ~/GIT$CL"
    fi
}

## Pregunta si generar enlace solo cuando falta uno de ellos
if [[ ! -h "$HOME/git" ]] &&
   [[ ! -h "$HOME/GIT" ]] &&
   [[ ! -h "$HOME/web" ]]; then
    enlaces
fi

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
