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

mariadb_descargar() {
    echo "$VE Descargando$RO mariadb$CL"
}

mariadb_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO mariadb"
}

mariadb_instalar() {
    echo -e "$VE Instalando$RO mariadb$VE y Complementos$CL"
    local software_servidor='mariadb-client mariadb-plugin-connect mariadb-server'
    local software_extra='phpmyadmin libreoffice-mysql-connector'

    instalarSoftware "$software_servidor" "$software_extra"
}

mariadb_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO MariaDB$CL"
    echo -e "$VE Creando usuario Desarrollador$RO dev$CL"
    sudo mysql -e "CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';"

    echo -e "$VE Asignando permisos en todas la bases de dato$CL"
    mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'dev'@'localhost';"

    echo -e "$VE Refrescando privilegios$CL"
    mysql -e "FLUSH PRIVILEGES;"

    echo -e "$VE Reiniciar servidor$RO MariaDB$CL"
    reiniciarServicio 'mariadb'
}

mariadb_instalador() {
    mariadb_descargar
    mariadb_preconfiguracion
    mariadb_instalar
    mariadb_postconfiguracion
}
