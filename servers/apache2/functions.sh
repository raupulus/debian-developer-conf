#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://.fryntiz.es
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## En este archivo se contienen las funciones auxiliares para el instalador
## de apache2 y sus sitios virtuales.

############################
##        FUNCTIONS       ##
############################
##
## Borra todo el contenido dentro de /var/www
##
apache2LimpiarSites() {
    pararServicio 'apache2'

    echo -e "$VE Cuidado, esto puede$RO BORRAR$VE algo valioso$RO$CL"
    read -p " ¿Quieres borrar todo el directorio ${DIRWEB}/* s/N → " input

    if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
        sudo rm -R ${DIRWEB}/*
        echo -e "$VE Directorio$VE $DIRWEB borrado$CL"
    else
        echo -e "$VE No se borra$RO $DIRWEB$CL"
    fi
}

##
## Añade el directorio con los archivos correspondientes para el sitio.
## $1 Nombre del directorio a copiar.
##
apache2AgregarDirectorio() {
    local site="$1"

    if [[ -z $site ]]; then
        echo -e "$RO No se ha pasado sitio a copiar$CL"
        return 1
    fi

    if [[ ! -d "$WORKSCRIPT/conf/var/www/${site}" ]]; then
        echo -e "$RO No existe directorio en este script para el sitio de apache$RO $site$CL"
    fi

    if [[ -d "${DIRWEB}/${site}" ]]; then
        echo -e "$VE Ya existe$RO ${DIRWEB}/${site}$VE, omitiendo$CL"
    fi

    echo -e "$VE Copiando estructura dentro de ${DIRWEB}/${site} $CL"
    sudo cp -R "$WORKSCRIPT/conf/var/www/${site}" "${DIRWEB}/${site}"

    ## Generando directorio para logs
    ##if [[ ! -d "/var/log/apache2/${site}.local" ]]; then
    echo -e "$VE Creando directorio para logs ${DIRWEBLOG}/${site}.local$CL"
    sudo mkdir "${DIRWEBLOG}/${site}.local"
    ##fi
}

##
## Agrega las configuraciones para el sitio virtual.
## $1 Recibe el nombre del archivo de configuración para el sitio virtual.
## $2 Recibe el nombre del directorio en /var/www para el sitio virtual.
##
apache2GenerarConfiguracion() {
    local conf="$1"
    local site="$2"

    if [[ -z $conf ]]; then
        echo -e "$RO No se ha pasado archivo de configuracion$CL"
        return 1
    fi

    if [[ ! -f "${WORKSCRIPT}/conf/etc/apache2/sites-available/${conf}" ]]; then
        echo -e "$VE No existe el archivo para el sitio de apache2 a copiar$CL"
        return 1
    fi

    if [[ -f "${APACHECONF}/${conf}" ]]; then
        echo -e "$VE Ya existe$RO ${APACHECONF}/${conf}, renovando...$CL"
        sudo rm "${APACHECONF}/${conf}"
    fi

    if [[ -d "${DIRWEB}/${site}" ]]; then
        echo -e "$VE Copiando configuración dentro de $APACHECONF$CL"

        ## Copia el contenido de configuración en apache2
        sudo cp -R "${WORKSCRIPT}/conf/etc/apache2/sites-available/${conf}" "${APACHESITES}/${conf}"
    else
        echo -e "$VE No existe el directorio para el sitio $site$CL"
    fi
}

##
## Comprueba si existe el sitio virtual
## $1 Recibe el nombre del archivo de configuración para el sitio virtual.
## $2 Recibe el nombre del directorio en /var/www para el sitio virtual.
## return boolean Devuelve "true" o "false"
##
apache2ExisteSitioVirtual() {
    local conf="${APACHESITES}/${1}"
    local dirWebHost="${DIRWEB}/${2}"

    if [[ -f $conf ]] && [[ -d $dirWebHost ]]; then
        echo 'true'
        return 1
    fi

    echo 'false'
    return 0
}

##
## Crea una entrada en /etc/hosts para el sitio pasado.
## $1 Recibe el nombre del sitio virtual.
##
apache2ActivarHost() {
    local sitioWeb="$1"
    local entradaHosts=$(cat '/etc/hosts' | grep "127.0.0.1    ${sitioWeb}.local")

    echo -e "$VE Añadiendo$RO Sitio Virtual$VE al archivo$RO /etc/hosts$AM y $RO /etc/hosts.local"

    ## TODO → Usar "sed" para añadir el host
    if [[ "$entradaHosts" != "127.0.0.1    ${sitioWeb}.local" ]]; then
        echo "127.0.0.1    ${sitioWeb}.local" | sudo tee -a '/etc/hosts'
    fi

    local entradaHostsLocal=$(cat '/etc/hosts.local' | grep "127.0.0.1    ${sitioWeb}.local")

    echo -e "$VE Añadiendo$RO Sitio Virtual$VE al archivo$RO /etc/hosts$AM"

    ## TODO → Usar "sed" para añadir el host local
    if [[ "$entradaHostsLocal" != "127.0.0.1    ${sitioWeb}.local" ]]; then
        if [[ ! -f '/etc/hosts.local' ]]; then
            sudo touch '/etc/hosts.local'
        fi

        echo "127.0.0.1    ${sitioWeb}.local" | sudo tee -a '/etc/hosts.local'
    fi
}

##
## Asigna los permisos al sitio recibido como parámetro.
## $1 Recibe el nombre del directorio web.
##
apache2AsignarPropietario() {
    local vhostName="$1"

    ## Cambia el dueño
    echo -e "$VE Asignando dueños$CL"

    if [[ -d "${DIRWEB}/${vhostName}" ]]; then
        sudo chown -R www-data:www-data "${DIRWEB}/${vhostName}"
        sudo chmod g+s -R "${DIRWEB}/${vhostName}"
    fi
}

##
## Asigna permisos al sitio virtual y su configuración.
## $1 Recibe el nombre del directorio en /var/www para el sitio virtual.
##
apache2AsignarPermisos() {
    local dirWebHost="${DIRWEB}/${1}"

    echo -e "$VE Asignando permisos a$RO Host Virtual$VE de$RO $dirWebHost$CL"
    if [[ -f "${dirWebHost}/.htpasswd" ]]; then
        sudo chmod 700 "${dirWebHost}/.htpasswd"
    fi

    if [[ -f "${dirWebHost}/CMS/.htpasswd" ]]; then
        sudo chmod 700 "${dirWebHost}/CMS/.htpasswd"
    fi
}

##
## Habilita los módulos recibidos como parámetro en apache2
## $* Lista de módulos
##
apache2HabilitarModulo() {
    if [[ "$DISTRO" = 'debian' ]] || [[ "$DISTRO" = 'raspbian' ]]; then
        for modulo in $*; do
            echo -e "$VE Activando módulo:$RO $modulo$CL"
            sudo a2enmod $modulo
        done
    elif [[ "$DISTRO" = 'gentoo' ]]; then
        for modulo in $*; do
            echo "no implementado en gentoo"
        done
    elif [[ "$DISTRO" = 'fedora' ]]; then
        for modulo in $*; do
            echo "no implementado en fedora"
        done
    elif [[ "$DISTRO" = 'macos' ]]; then
        for modulo in $*; do
            echo "No necesario en macos, se habilita en configuracion httpd.conf"
        done
    fi
}

##
## Deshabilita los módulos recibidos como parámetro en apache2
## $* Lista de módulos
##
apache2DeshabilitarModulo() {
    if [[ "$MY_DISTRO" = 'debian' ]] || [[ "$MY_DISTRO" = 'raspbian' ]]; then
        for modulo in $*; do
            echo -e "$VE Desactivando módulo:$RO $modulo$CL"
            sudo a2dismod $modulo
        done
    elif [[ "$MY_DISTRO" = 'gentoo' ]]; then
        for modulo in $*; do
            echo "no implementado en gentoo"
        done
    elif [[ "$MY_DISTRO" = 'fedora' ]]; then
        for modulo in $*; do
            echo "no implementado en fedora"
        done
    elif [[ "$DISTRO" = 'macos' ]]; then
        for modulo in $*; do
            echo "No necesario en macos"
        done
    fi
}

##
## Habilitar los sitios apache2 recibidos.
## $* Lista de sitios para habilitar.
##
apache2HabilitarSitio() {
    if [[ "$MY_DISTRO" = 'debian' ]] || [[ "$MY_DISTRO" = 'raspbian' ]]; then
        for sitio in $*; do
            echo -e "$VE Activando sitio:$RO $sitio$CL"
            sudo a2ensite $sitio
        done
    elif [[ "$MY_DISTRO" = 'gentoo' ]]; then
        for sitio in $*; do
            echo "no implementado en gentoo"
        done
    elif [[ "$MY_DISTRO" = 'fedora' ]]; then
        for sitio in $*; do
            echo "no implementado en fedora"
        done
    fi
}

##
## Deshabilita los sitios apache2 recibidos.
## $* Lista de sitios a deshabilitar.
##
apache2DeshabilitarSitio() {
    if [[ "$MY_DISTRO" = 'debian' ]] || [[ "$MY_DISTRO" = 'raspbian' ]]; then
        for sitio in $*; do
            echo -e "$VE Desactivando sitio:$RO $sitio$CL"
            sudo a2dissite $sitio
        done
    elif [[ "$MY_DISTRO" = 'gentoo' ]]; then
        for sitio in $*; do
            echo "no implementado en gentoo"
        done
    elif [[ "$MY_DISTRO" = 'fedora' ]]; then
        for sitio in $*; do
            echo "no implementado en fedora"
        done
    fi
}
