#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
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

############################
##        FUNCIONES       ##
############################

apache2_descargar() {
    echo "$VE Descargando$RO Apache2$CL"
}

apache2_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Apache2"
}

apache2_instalar() {
    echo -e "$VE Instalando$RO Apache2$CL"
    local dependencias="apache2 libapache2-mod-perl2 libapache2-mod-php libapache2-mod-python"
    instalarSoftware "$dependencias"
}

apache2_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de Apache2"

    echo -e "$VE Activando módulos$RO"
    sudo a2enmod rewrite

    echo -e "$VE Desactivando módulos$RO"
    sudo a2dismod php5

    personalizar_apache() {
        clear
        echo -e "$VE Personalizando$RO Apache2$CL"
        generar_www() {
            ## Borrar contenido de /var/www
            sudo systemctl stop apache2
            echo -e "$VE Cuidado, esto puede$RO BORRAR$VE algo valioso$RO"
            read -p " ¿Quieres borrar todo el directorio /var/www/? s/N → " input
            if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
                sudo rm -R /var/www/*
            else
                echo -e "$VE No se borra$RO /var/www$CL"
            fi

            ## Copia todo el contenido WEB a /var/www
            echo -e "$VE Copiando contenido dentro de /var/www"
            sudo cp -R $WORKSCRIPT/Apache2/www/* /var/www/

            ## Copia todo el contenido de configuración a /etc/apache2
            echo -e "$VE Copiando archivos de configuración dentro de /etc/apache2"
            sudo cp -R $WORKSCRIPT/Apache2/etc/apache2/* '/etc/apache2/'

            ## Crear archivo de usuario con permisos para directorios restringidos
            echo -e "$VE Creando usuario con permisos en apache"
            sudo rm /var/www/.htpasswd 2>> /dev/null
            while [[ -z "$input_user" ]]; do
                read -p "Nombre de usuario para acceder al sitio web privado → " input_user
            done
            echo -e "$VE Introduce la contraseña para el sitio privado:$RO"
            sudo htpasswd -c /var/www/.htpasswd $input_user

            ## Cambia el dueño
            echo -e "$VE Asignando dueños$CL"
            sudo chown www-data:www-data -R /var/www
            sudo chown root:root /etc/apache2/ports.conf

            ## Agrega el usuario al grupo www-data
            echo -e "$VE Añadiendo el usuario al grupo$RO www-data"
            sudo adduser "$USER" 'www-data'
        }

        echo -e "$VE Es posible generar una estructura dentro de /var/www"
        echo -e "$VE Ten en cuenta que esto borrará el contenido actual"
        echo -e "$VE También se modificarán archivos en /etc/apache2/*$RO"
        read -p " ¿Quieres Generar la estructura y habilitarla? s/N → " input
        if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
            generar_www
        else
            echo -e "$VE No se genera la estructura predefinida y automática"
        fi

        ## Generar enlaces (desde ~/web a /var/www)
        enlaces() {
            clear
            echo -e "$VE Puedes generar un enlace en tu home ~/web hacia /var/www/html"
            read -p " ¿Quieres generar el enlace? s/N → " input
            if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
                sudo ln -s '/var/www/html/' "/home/$USER/web"
                sudo chown -R "$USER:www-data" "/home/$USER/web"
            else
                echo -e "$VE No se crea enlace desde ~/web a /var/www/html"
            fi

            clear
            echo -e "$VE Puedes crear un directorio para repositorios$RO GIT$VE en tu directorio personal"
            echo -e "$VE Una vez creado se añadirá un enlace al servidor web"
            echo -e "$VE Este será desde el servidor /var/www/html/Publico/GIT a ~/GIT$RO"
            read -p " ¿Quieres crear el directorio y generar el enlace? s/N → " input
            if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
                if [[ ! -d "$HOME/GIT" ]]; then
                    echo -e "$VE Creando directorio$RO $HOME/GIT$VE"
                    mkdir "$HOME/GIT"
                fi

                ## Creando enlaces en el directorio Home
                if [[ ! -h '/var/www/html/Publico/GIT' ]]; then
                    sudo ln -s "$HOME/GIT" '/var/www/html/Publico/GIT'
                    sudo chown -R "www-data:www-data" "/home/$USER/GIT"
                    sudo chmod g+s "/home/$USER/GIT"
                fi

                if [[ ! -h "$HOME/git" ]] && [[ -h "$HOME/GIT" ]]; then
                    sudo ln -s "$HOME/GIT" "$HOME/git"
                fi
            else
                echo -e "$VE No se crea enlaces ni directorio ~/GIT"
            fi
        }

        enlaces

        ## Cambia los permisos
        echo -e "$VE Asignando permisos"
        ## TOFIX → Función para los permisos
        sudo chmod 775 -R /var/www/*
        sudo chmod 700 '/var/www/.htpasswd'
        sudo chmod 700 '/var/www/html/Privado/.htaccess'
        sudo chmod 700 '/var/www/html/Publico/.htaccess'
        sudo chmod 700 '/var/www/html/Privado/CMS/.htaccess'
        sudo chmod 755 '/etc/apache2/ports.conf' '/etc/apache2/'
        sudo chmod 755 -R '/etc/apache2/sites-available' '/etc/apache2/sites-enabled'

        ## Habilita Sitios Virtuales (VirtualHost)
        sudo a2ensite 'default.conf'
        sudo a2ensite 'publico.conf'
        sudo a2ensite 'privado.conf'

        ## Deshabilita Sitios Virtuales (VirtualHost)
        sudo a2dissite '000-default.conf'

        activar_hosts() {
            echo -e "$VE Añadiendo$RO Sitios Virtuales$AM"
            echo '127.0.0.1 privado' | sudo tee -a '/etc/hosts'
            echo '127.0.0.1 privado.local' | sudo tee -a '/etc/hosts'
            echo '127.0.0.1 p.local' | sudo tee -a '/etc/hosts'
            echo '127.0.0.1 publico' | sudo tee -a '/etc/hosts'
            echo '127.0.0.1 publico.local' | sudo tee -a '/etc/hosts'
        }

        read -p " ¿Quieres añadir sitios virtuales a /etc/hosts? s/N → " input
        if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
            activar_hosts
        else
            echo -e "$VE No se añade nada a$RO /etc/hosts$CL"
        fi
    }

    personalizar_apache
}


apache2_instalador() {
    apache2_descargar
    apache2_preconfiguracion
    apache2_instalar
    apache2_postconfiguracion

    ## Reiniciar servidor Apache para aplicar configuración
    reiniciarServicio apache2
}
