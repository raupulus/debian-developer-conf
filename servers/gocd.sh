#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################

gocd_download() {
    echo -e "$VE Descargando$RO GoCD$CL"
}

gocd_before_install() {
    echo -e "$VE Generando Pre-Configuraciones de$RO GoCD$CL"

    ## Comprueba si postgresql está instalado o pregunta si instalarlo
    if [[ ! -f '/usr/bin/psql' ]]; then
        echo -e "$RO Postgresql no está instalado en el sistema!!!$CL"

        sleep 2

        while [[ -z "$input_user" ]]; do
            read -p " ¿Quieres instalar postgresql? s/N → " input_user
        done

        if [[ "$input_user" = 's' ]] || [[ "$input_user" = 'S' ]]; then
            postgresql_installer
        fi
    fi

    sudo groupadd gocd
    sudo usermod -a -G gocd "$USER"

    if [[ ! -d '/mnt/artifact-storage' ]]; then
        sudo mkdir '/mnt/artifact-storage'
        sudo chown go:go '/mnt/artifact-storage'
        sudo chmod ugo+rx -R '/mnt/artifact-storage'
        sudo chmod ug+w -R '/mnt/artifact-storage'
        sudo chmod g+s -R '/mnt/artifact-storage'
    fi
}

gocd_install() {
    echo -e "$VE Instalando$RO GoCD$CL"
    instalarSoftwareLista "${SOFTLIST}/servers/gocd.lst"
}

gocd_after_install() {
    echo -e "$VE Generando Post-Configuraciones de$RO GoCD$CL"

    echo -e "$VE Creando contraseña para el usuario$RO $USER$CL"
    sudo htpasswd -B -c /etc/go/authentication "${USER}"
    sudo chmod 755 /etc/go/authentication
    sudo chown go:go /etc/go/authentication

    echo -e "$VE Iniciando servidor, comprueba estado y pulsa cualquier tecla$CL"
    sudo systemctl start go-server go-agent
    sudo systemctl status go-*

    echo ""
    read -p "Pulsa cualquier INTRO para continuar" nullparam

    echo -e "$VE Comprueba puertos abiertos http y https:$RO 8153$AM y$RO 8154$CL"
    sudo watch netstat -plnt

    echo ""
    read -p "Pulsa cualquier INTRO para continuar" nullparam

    echo -e "$VE Actualizando$RO certificados$CL"
    sudo update-ca-certificates -f


    ## Creo tabla para postgresql
    echo -e "$VE Creando DB en$RO Postgresql$VE y asignándole$RO Usuario$CL"

    while [[ -z "$gocd_database_user" ]]; do
        read -p " Introduce un usuario para la nueva DB gocd → " gocd_database_user
    done

    while [[ -z "$gocd_database_password" ]]; do
        read -p " Introduce una contraseña para la nueva DB gocd → " gocd_database_password
    done

    sudo -u postgres psql -c CREATE ROLE "${gocd_database_user}" PASSWORD "${gocd_database_password}" NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;

    sudo -u postgres psql -c CREATE DATABASE "gocd" ENCODING="UTF8" TEMPLATE="template0";

    sudo -u postgres psql -c GRANT ALL PRIVILEGES ON DATABASE "gocd" TO "${gocd_database_user}";

    ## TOFIX → Actualmente se usa así en el servidor de pruebas, no debe ser SUPERUSER
    sudo -u postgres psql -c ALTER ROLE "${gocd_database_user}" SUPERUSER;


    echo -e "$VE Configurando archivos de servidor para usar la nueva db$RO postgresql$CL"
    GO_SERVER_CONFIG='/usr/share/go-server/wrapper-config/wrapper-properties.conf'
    echo '## Database' | sudo tee -a GO_SERVER_CONFIG
    echo 'db.driver=org.postgresql.Driver' | sudo tee -a GO_SERVER_CONFIG
    echo "db.user=${gocd_database_user}" | sudo tee -a GO_SERVER_CONFIG
    echo "db.password=${gocd_database_password}" | sudo tee -a GO_SERVER_CONFIG


    # MENSAJES PARA HACER MANUALMENTE EN LA INTERFAZ
    # TODO → ESTO SE PUEDE HACER DESDE ARCHIVOS SEGURO, MIRAR
    echo -e "$RO Ya solo queda configurar manualmente desde el dashboard las siguientes cosas:$CL"
    echo ""
    echo -e "$VE Entrar a la url$RO /go/admin/security/auth_configs$CL"
    echo -e "$VE id →$RO file_authentication$CL"
    echo -e "$VE plugin id →$RO Password File Authentication$CL"
    echo -e "$VE password file path →$RO /etc/go/authentication$CL"
    echo -e "$VE Allow only known users to login →$RO False$CL"
    echo ""
    echo -e "$VE Entrar en configuración y cambiar storage de artifacts al
    siguiente →$RO :8153/go/admin/config/server#!artifact-management$CL"

    read -p " Pulse intro para terminar y volver al menú" nullparam
}

gocd_installer() {
    gocd_download
    gocd_before_install

    ## Compruebo si está postgresql o aborta instalación
    if [[ ! -f '/usr/bin/psql' ]]; then
        echo -e "$VE Es necesario tener instalado$RO PostgreSql$CL"
        echo -e "$VE Para otro tipo de configuración deberá continuar$RO Manualmente$CL"
        echo -e "$RO ABORTANDO INSTALACIÓN DE GOCD!!!$CL"
        return 0
    fi

    gocd_install
    gocd_after_install

    reiniciarServicio 'go-server'
    sleep 5
    reiniciarServicio 'go-agent'
}
