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
## Instala, configura y personaliza el SGBD para bases de datos MariaDB tanto
## cliente como servidor y phpmyadmin para gesión via interfaz web.
##
## Además se propone la creación de un usuario para desarrollar con el
## nombre para este "dev" y contraseña "dev"

############################
##        FUNCIONES       ##
############################

mariadb_descargar() {
    echo -e "$VE Descargando$RO mariadb$CL"
}

mariadb_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO mariadb"

    sudo groupadd mysql
    sudo usermod -a -G mysql "$USER"
}

mariadb_instalar() {
    echo -e "$VE Instalando$RO mariadb$VE y Complementos$CL"
    instalarSoftwareLista "${SOFTLIST}/Servidores/mariadb.lst"
}

mariadb_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO MariaDB$CL"

    local FILE_CONF='/etc/mysql/mariadb.conf.d/50-server.cnf'

    echo -e "$VE Estableciendo character-set-server = utf8mb4$CL"
    sudo sed -r -i "s/^\s*#?\s*character-set-server\s*=.*/character-set-server  = utf8mb4/" "$FILE_CONF"

    echo -e "$VE Estableciendo collation-server = utf8mb4_general_ci$CL"
    sudo sed -r -i "s/^\s*#?\s*collation-server\s*=.*/collation-server      = utf8mb4_general_ci/" "$FILE_CONF"

    ## Plantea la creación de un usuario llamado "dev" para desarrollar
    crearUsuario() {
        read -p " ¿Quieres crear el usuario desarrollador: dev? s/N → " input
        if [[ "$input" = 's' ]] || [[ "$input" = 'S' ]]; then
            echo -e "$VE Creando usuario Desarrollador$RO dev$CL"
            sudo mysql -e "CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';"

            echo -e "$VE Asignando permisos en todas la bases de datos$CL"
            sudo mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'dev'@'localhost';"

            echo -e "$VE Refrescando privilegios$CL"
            sudo mysql -e "FLUSH PRIVILEGES;"

            echo -e "$VE Reiniciar servidor$RO MariaDB$CL"
            reiniciarServicio 'mariadb'
        else
            echo -e "$VE No se crea usuario$CL"
        fi
    }

    crearUsuario
}

mariadb_instalador() {
    mariadb_descargar
    mariadb_preconfiguracion
    mariadb_instalar
    mariadb_postconfiguracion
}
