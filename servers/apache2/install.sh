#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2019 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://.fryntiz.es
## @gitlab     https://gitlab.com/fryntiz
## @github     https://github.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
## Este script prepara el sistema, instala y configura apache2.
## También agrega los sitios virtuales desde una plantilla básica.


############################
##     IMPORTACIONES      ##
############################
source "$WORKSCRIPT/servers/apache2/functions.sh"
source "$WORKSCRIPT/servers/apache2/site-default.sh"
source "$WORKSCRIPT/servers/apache2/site-private.sh"
source "$WORKSCRIPT/servers/apache2/site-public.sh"

############################
##        FUNCTIONS       ##
############################
##
## Descarga e instala la base para apache2.
##
apache2_download() {
    echo -e "$VE Descargando$RO Apache2$CL"
}

##
## Preconfigura apache2 antes de su instalación.
##
apache2_before_install() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Apache2"

    if [[ $DISTRO = 'macos' ]]; then
        sudo apachectl stop 2> /dev/null

        ## Evita reinicios por scripts del apache que trae el sistema.
        sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null


        ## Crea el grupo para apache y asigna al usuario actual.
        sudo dscl . -create /Groups/www-data
        sudo dscl . -create /Groups/www-data name www-data

        ## Añade el usuario actual al nuevo grupo para apache.
        sudo dseditgroup -o edit -a $USER -t user www-data
    fi
}

##
## Instala las dependencias para apache2.
##
apache2_install() {
    echo -e "$VE Instalando$RO Apache2$CL"

    instalarSoftwareLista "${SOFTLIST}/servers/apache2.lst"
}

##
## Acciones después de instalar apache2
##
apache2_after_install() {
    echo -e "$VE Acciones tras instalar$RO Apache2$CL"

    if [[ $DISTRO = 'macos' ]]; then
        #brew services start httpd
        sudo apachectl start

        if [[ ! -f $APACHESITES ]];then
            sudo touch $APACHESITES
            sudo chown ${USER}:admin $APACHESITES
            sudo chmod 644 $APACHESITES
        fi

        if [[ ! -f $APACHEPORTSCONF ]];then
            sudo touch $APACHEPORTSCONF
            sudo cp "$WORKSCRIPT/conf/etc/apache2/ports.conf" "$APACHEPORTSCONF"
            sudo chown ${USER}:admin $APACHEPORTSCONF
            sudo chmod 644 $APACHEPORTSCONF
        fi


    else
        ## Configuración de puertos usados por apache.
        sudo cp "$WORKSCRIPT/conf/etc/apache2/ports.conf" "$APACHEPORTSCONF"

        ## Preparo configuración de módulos disponibles en apache2.
        sudo cp ${WORKSCRIPT}/conf/etc/apache2/mods-available/* "$APACHEMODS"
    fi

    ## Creo almacenamiento para aplicaciones
    if [[ ! -d "${DIRWEB}" ]]; then
        sudo mkdir "${DIRWEB}"
        sudo chown ${USER}:www-data -R "${DIRWEB}"
        sudo chmod 770 -R "${DIRWEB}"
        sudo chmod ug+s -R "${DIRWEB}"
        sudo umask 117 -R "${DIRWEB}"
    fi

    ## Creo almacenamiento para aplicaciones
    if [[ ! -d "${DIRWEB}/storage" ]]; then
        sudo mkdir "${DIRWEB}/storage"
        sudo chown ${USER}:www-data -R "${DIRWEB}/storage"
        sudo chmod 770 -R "${DIRWEB}/storage"
        sudo chmod ug+s -R "${DIRWEB}/storage"
        sudo umask 117 -R "${DIRWEB}/storage"
    fi

    ## Creo lugar para sitios públicos
    if [[ ! -d "${DIRWEB}/public" ]]; then
        sudo mkdir "${DIRWEB}/public"
        sudo chown ${USER}:www-data -R "${DIRWEB}/public"
        sudo chmod 770 -R "${DIRWEB}/public"
        sudo chmod ug+s -R "${DIRWEB}/public"
        sudo umask 117 -R "${DIRWEB}/public"
    fi

    ## Creo lugar para sitios públicos
    if [[ ! -d "${DIRWEB}/public/default" ]]; then
        sudo mkdir "${DIRWEB}/public/default"
        sudo chown ${USER}:www-data -R "${DIRWEB}/public/default"
        sudo chmod 770 -R "${DIRWEB}/public/default"
        sudo chmod ug+s -R "${DIRWEB}/public/default"
        sudo umask 117 -R "${DIRWEB}/public/default"

        echo '<h1>Sitio por defecto Creado</h1>' > "${DIRWEB}/public/default/index.html"
    fi

    ## Creo lugar para sitios privados
    if [[ ! -d "${DIRWEB}/private" ]]; then
        sudo mkdir "${DIRWEB}/private"
        sudo chown ${USER}:www-data -R "${DIRWEB}/private"
        sudo chmod 770 -R "${DIRWEB}/private"
        sudo chmod ug+s -R "${DIRWEB}/private"
        sudo umask 117 -R "${DIRWEB}/private"
    fi

    if [[ -f "${DIRWEB}/.htpasswd" ]]; then
        sudo chown ${USER}::www-data "${DIRWEB}/.htpasswd"
    fi
}

##
## Asigna propietario a los sitios virtuales y su configuración.
##
apache2Propietarios() {
    ## Cambia el dueño
    echo -e "$VE Asignando dueños$CL"
    sudo chown root:root "$APACHEPORTSCONF"
    sudo chown root:root -R "$APACHEMODS"


    ## Agrega el usuario al grupo www-data
    echo -e "$VE Añadiendo el usuario al grupo$RO www-data"
    sudo adduser "$USER" 'www-data'

    ## Cada archivo/directorio creado tomará el grupo www-data

    if [[ -d "${DIRWEB}" ]] && [[ -f "${DIRWEB}/.htpasswd" ]]; then
        sudo chown 'www-data:www-data' "${DIRWEB}/.htpasswd"
    fi

    ## Adopto directorio de repositorios git
    if [[ -d '/var/git' ]]; then
        sudo chown -R "$USER":www-data '/var/git'
        sudo chmod 770 -R '/var/git'
        sudo chmod g+s -R '/var/git'
        sudo su root -c "umask 117 -R /var/www/storage"
    fi

    if [[ -d "${HOME}/git" ]]; then
        sudo chown -R "$USER":www-data "${HOME}/git"
        sudo chmod g+s -R "${HOME}/git"
        sudo su root -c "umask 117 -R ${HOME}/git"
    fi
}

##
## Asigna los permisos para los sitios virtuales y la configuración.
##
apache2Permisos() {
    echo -e "$VE Asignando permisos$RO Configuración$CL"
    sudo chmod 755 "$APACHEPORTSCONF"
    sudo chmod 750 "$APACHEAPACHE2CONF"
    sudo chmod 644 -R "$APACHEMODS"
    sudo chmod 755 "$APACHEMODS"


    echo -e "$VE Asignando permisos a$RO Hosts Virtuales$CL"
    sudo chmod ug+rw -R ${DIRWEB}/*
    sudo chmod 700 "${DIRWEB}/.htpasswd"
    sudo chmod 755 "${APACHECONF}/"
    sudo chmod 755 -R "$APACHESITES" "$APACHESITESENABLED"
}

##
## Agrega y habilita certificado ssl y módulo.
##
apache2Ssl() {
    ## Instalar módulo SSL
    apache2HabilitarModulo 'ssl'
    reiniciarServicio apache2

    ## Comprobar que está activo y abierto el puerto
    if [[ -x '/bin/netstat' ]]; then
        netstat -nl | grep 443
    fi

    sudo iptables -nL | grep 443

    ## Crear certificado autofirmado
    if [[ ! -d "${APACHECONF}/ssl" ]]; then
        sudo mkdir "${APACHECONF}/ssl"
    fi

    sudo chmod 700 -R "${APACHECONF}/ssl"

    ## Solo autofirmo certificados cuando no estoy en producción.
    if [[ "$MY_ENV" != 'prod' ]]; then
        ## Genero certificados para localhost en caso de no existir
        local existe=$(sudo ls "${APACHECONF}/ssl/localhost.key" 2>> /dev/null)
        local existe1=$(sudo ls "${APACHECONF}/ssl/localhost.csr" 2>> /dev/null)
        local existe2=$(sudo ls "${APACHECONF}/ssl/localhost.crt" 2>> /dev/null)

        if [[ ! "$existe" = "${APACHECONF}/ssl/localhost.key" ]]; then
            if [[ ! "$existe1" = "${APACHECONF}/ssl/localhost.csr" ]]; then
                sudo rm "${APACHECONF}/ssl/localhost.csr"
            fi

            if [[ ! "$existe2" = "${APACHECONF}/ssl/localhost.crt" ]]; then
                sudo rm "${APACHECONF}/ssl/localhost.crt"
            fi

            sudo openssl genrsa -des3 -out ${APACHECONF}/ssl/localhost.key 4096
            sudo openssl req -new -key \
                ${APACHECONF}/ssl/localhost.key \
                -out ${APACHECONF}/ssl/localhost.csr

            sudo openssl x509 -req -days 5000 \
                -in ${APACHECONF}/ssl/localhost.csr \
                -signkey ${APACHECONF}/ssl/localhost.key \
                -out ${APACHECONF}/ssl/localhost.crt


            ## Muevo el .key para quitar que pida la contraseña
            sudo mv "${APACHECONF}/ssl/localhost.key" "${APACHECONF}/ssl/localhostBACKUP.key"
            sudo openssl rsa -in "${APACHECONF}/ssl/localhostBACKUP.key" -out "${APACHECONF}/ssl/localhost.key"
            sudo rm "${APACHECONF}/ssl/localhostBACKUP.key"
        fi
    fi

    sudo chmod 600 -R "${APACHECONF}/ssl/"
}

##
## Agrega configuraciones de seguridad y permisos para los sitios virtuales.
##
apache2DefaultSiteSecurity() {
    if [[ ! -f "${DIRWEB}/.htpasswd" ]]; then
        ## Crear archivo de usuario con permisos para directorios restringidos
        echo -e "$VE Creando usuario con permisos en apache"

        while [[ -z "$input_user" ]]; do
            read -p "Nombre de usuario para acceder a los sitios web privado → " input_user
        done

        echo -e "$VE Introduce la contraseña para los sitios web privados:$RO"
        sudo htpasswd -c "${DIRWEB}/.htpasswd" $input_user
    fi
}

##
## Generar enlaces:
## ~/web a /var/www
## ~/git a /var/www/private/git
##
apache2GenerarEnlaces() {
    ## Creo enlace al directorio web.
    if [[ ! -h "$HOME/www" ]] &&
       [[ -d "$DIRWEB" ]]; then
        echo -e "$VE Creando enlace desde$RO ${HOME}/www$VE hasta$RO $DIRWEB$CL"

        sudo ln -s "$DIRWEB" "${HOME}/www"
        sudo chown "$USER:www-data" "${HOME}/www"
    fi

    ## Creo enlace a repositorios "git" en zona privada.
    if [[ -d "$HOME/git" ]] &&
       [[ "$ENV" = 'dev' ]] &&
       [[ -d "${DIRWEB}/private" ]] &&
       [[ ! -h "${DIRWEB}/private/git" ]];
    then
        echo -e "$VE Creando enlace desde$RO ${HOME}/git$VE hasta$RO ${DIRWEB}/private$CL"
        sudo ln -s "$HOME/git" "${DIRWEB}/private/git"
    fi
}

apache2_macos_installer() {
    sudo apachectl stop 2>/dev/null
    sudo launchctl unload /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

    if [[ -d "${HOME}/git" ]]; then
        sudo chown -R ${USER}:staff "${HOME}/git"
        sudo chmod -R g+s "${HOME}/git"
        sudo su root -c "umask 117 -R ${HOME}/git"
    fi

     ## Creo almacenamiento para aplicaciones
    if [[ ! -d "${DIRWEB}" ]]; then
        sudo mkdir "${DIRWEB}"
        sudo chown -R ${USER}:staff "${DIRWEB}"
        sudo chmod -R 770 "${DIRWEB}"
        sudo chmod -R ug+s "${DIRWEB}"
        sudo umask 117 -R "${DIRWEB}"
    fi

    ## Creo almacenamiento para aplicaciones
    if [[ ! -d "${DIRWEB}/storage" ]]; then
        sudo mkdir "${DIRWEB}/storage"
        sudo chown -R ${USER}:staff "${DIRWEB}/storage"
        sudo chmod -R 770 "${DIRWEB}/storage"
        sudo chmod -R ug+s  "${DIRWEB}/storage"
        sudo umask 117 -R "${DIRWEB}/storage"
    fi

    ## Creo lugar para sitios públicos
    if [[ ! -d "${DIRWEB}/public" ]]; then
        sudo mkdir "${DIRWEB}/public"
        sudo chown -R ${USER}:staff "${DIRWEB}/public"
        sudo chmod -R 770 "${DIRWEB}/public"
        sudo chmod -R ug+s "${DIRWEB}/public"
        sudo umask 117 -R "${DIRWEB}/public"
    fi

    ## Creo lugar para sitios públicos
    if [[ ! -d "${DIRWEB}/public/default" ]]; then
        sudo mkdir "${DIRWEB}/public/default"
        sudo touch "${DIRWEB}/public/default/index.html"
        sudo chown -R ${USER}:staff "${DIRWEB}/public/default"
        sudo chmod -R 770 "${DIRWEB}/public/default"
        sudo chmod -R ug+s "${DIRWEB}/public/default"
        sudo umask 117 -R "${DIRWEB}/public/default"

        echo '<h1>Sitio por defecto Creado</h1>' > "${DIRWEB}/public/default/index.html"
    fi

    ## Creo lugar para sitios privados
    if [[ ! -d "${DIRWEB}/private" ]]; then
        sudo mkdir "${DIRWEB}/private"
        sudo chown -R ${USER}:staff "${DIRWEB}/private"
        sudo chmod -R 770 "${DIRWEB}/private"
        sudo chmod -R ug+s "${DIRWEB}/private"
        sudo umask 117 -R"${DIRWEB}/private"
    fi

    apache2DefaultSiteSecurity

    if [[ -f "${DIRWEB}/.htpasswd" ]]; then
        sudo chown ${USER}:staff "${DIRWEB}/.htpasswd"
    fi

    ## Creo enlace a repositorios "git" en zona privada.
    if [[ -d "$HOME/git" ]] &&
       [[ "$ENV" = 'dev' ]] &&
       [[ -d "${DIRWEB}/private" ]] &&
       [[ ! -h "${DIRWEB}/private/git" ]];
    then
        echo -e "$VE Creando enlace desde$RO ${HOME}/git$VE hasta$RO ${DIRWEB}/private$CL"
        sudo ln -s "$HOME/git" "${DIRWEB}/private/git"
    fi

    brew install httpd

    which apachectl

    sudo apachectl -k start
    brew services start httpd

    ## Comprobar problemas al iniciar apache, monitorizar:
    #tail -n 500 -f /opt/homebrew/var/log/httpd/error_log

    ## Comprobar accesos
    #tail -n 500 -f /opt/homebrew/var/log/httpd/access_log

    ## Directorio de configuraciones
    #/opt/homebrew/etc/httpd

    ## Comandos de gestión apache
    #sudo apachectl start
    #sudo apachectl stop
    #sudo apachectl -k restart
    #sudo apachectl configtest


    cd /opt/homebrew/etc/httpd
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt
    cd $WORKSCRIPT
}

apache2_installer() {

    if [[ $DISTRO = 'macos' ]]; then
        apache2_macos_installer
        mysql -u dev -p < /opt/homebrew/Cellar/phpmyadmin/5.2.0/share/phpmyadmin/sql/create_tables.sql
        return
    fi

    apache2_download
    apache2_before_install
    apache2_install
    apache2_after_install

    if [[ -d "${DIRWEB}" ]] && [[ ! -f "${DIRWEB}/.htpasswd" ]]; then
        apache2DefaultSiteSecurity
    fi

    if [[ -z "$DIRWEB" ]] ||
       [[ -z "$DIRWEBLOG" ]] ||
       [[ -z "$APACHECONF" ]];
    then
        echo -e "$VE No existe directorio de$RO Apache declarado$CL"
        exit 1
    fi

    if [[ -f "${APACHESITES}/000-default.conf" ]]; then
        apache2DeshabilitarSitio '000-default.conf'
    fi

    apache2LimpiarSites
    apache2HabilitarModulo rewrite ssl access_compat authn_file filter \
           negotiation autoindex env python socache_shmcb alias auth authz_core \
           deflate filter perl reqtimeout ssl auth_basic authz_host dir mime \
           status authn_core authz_user dnssd mpm_prefork setenvif proxy_http2 \
           headers http2 suexec status deflate auth_digest auth_basic cgi fcgid \
           proxy proxy_fcgi proxy_http evasive

    apache2DeshabilitarModulo 'php5'
    apache2Ssl

    ## Habilito sitios virtuales solo en desarrollo.
    if [[ "$ENV" = 'dev' ]]; then
        if [[ $DISTRO != 'macos' ]]; then
            apacheDefaultSiteCreate
            apachePublicSiteCreate
            apachePrivateSiteCreate
        fi
    fi

    ## Genero enlaces.
    apache2GenerarEnlaces

    ## Propietario y permisos
    if [[ $DISTRO != 'macos' ]]; then
        apache2Propietarios
        apache2Permisos
    fi

    ## Reiniciar servidor Apache para aplicar configuración
    reiniciarServicio 'apache2'
}
