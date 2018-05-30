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
## Instala y configura bind 9 dejando el servicio desactivado.

############################
##        FUNCIONES       ##
############################

bind_descargar() {
    echo -e "$VE Descargando$RO Bind 9$CL"
}

bind_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO Bind 9"
}

bind_instalar() {
    echo -e "$VE Instalando$RO Bind 9$CL"
    local software='bind9 bind9utils'
    instalarSoftware "$software"
}

bind_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de Bind 9$CL"

    echo -e "$VE Creando Backups$CL"
    crearBackup '/etc/bind/named.conf' '/etc/bind/named.conf.local'

    local dominio=''
    local zona='master'  ## master/slave
    local ipzona=''
    local ipzonainv=''
    local reenviador1='8.8.8.8'
    local reenviador2='8.8.4.4'

    while [[ "$dominio" == '' ]]:; do
        clear
        echo -e "$AM Introduce el nombre de$RO dominio:$CL"
        read -p 'Dominio → ' dominio
    done

    while [[ "$ipzona" == '' ]]:; do
        clear
        echo -e "$AM Introduce la$RO IP$VE:$CL"
        read -p 'IP → ' ipzona
    done

    while [[ "$ipzonainv" == '' ]]:; do
        clear
        echo -e "$AM Introduce los 3 primeros bloques de la$RO IP$VE al revés (1.168.192):$CL"
        read -p 'IP → ' ipzona
    done

    echo -e "$VE ¿Quieres limpiar configuraciones anteriores?$CL"
    echo -e "$VE Elegir$RO SI$VE puede$RO Borrar$VE conviguraciones"
    read -p ' s/N → ' input
    if [[ "$input" == 's' ]] || [[ "$input" == 'S' ]]; then
        echo '' | sudo tee '/etc/bind/named.conf.local'
    fi

    echo -e "$VE Creando zonas:$RO directa$VE e$RO inversa$CL"

    ## Creando Zona Directa:
    sudo cp '/etc/bind/db.local' "/etc/bind/db.${dominio}"
    sudo echo "zone \"$dominio\" {" >> '/etc/bind/named.conf.local'
    sudo echo "    type ${zona};" >> '/etc/bind/named.conf.local'
    sudo echo "    //also-notify \{192.168.1.2\};" >> '/etc/bind/named.conf.local'
    sudo echo "    file \"/etc/bind/db.${dominio}\";" >> '/etc/bind/named.conf.local'
    sudo echo '};'

    ## Creando Zona Inversa:
    sudo cp '/etc/bind/db.127' "/etc/bind/db.${ipzonainv}.rev"
    sudo echo "zone \"${ipzonainv}.in-addr.arpa\" {" >> '/etc/bind/named.conf.local'
    sudo echo "    type ${zona};" >> '/etc/bind/named.conf.local'
    sudo echo "    //also-notify \{192.168.1.2\};" >> '/etc/bind/named.conf.local'
    sudo echo "    file \"/etc/bind/db.${ipzonainv}.rev\";" >> '/etc/bind/named.conf.local'
    sudo echo '};'

    ## Reenviadores
    echo -e "$VE Configurando$RO reenviadores$CL"
    local optns='/etc/bind/named.conf.options'
    sudo echo "options {" > "$optns"
    sudo echo "        directory \"/var/cache/bind\";" >> "$optns"
    sudo echo "        forwarders {" >> "$optns"
    sudo echo "            $reenviador1;" >> "$optns"
    sudo echo "            $reenviador2;" >> "$optns"
    sudo echo "        };" >> "$optns"
    sudo echo "" >> "$optns"
    sudo echo "        dnssec-validation auto;" >> "$optns"
    sudo echo "" >> "$optns"
    sudo echo "        auth-nxdomain no;    # conform to RFC1035" >> "$optns"
    sudo echo "        listen-on-v6 { any; };" >> "$optns"
    sudo echo "};" >> "$optns"
}

bind_instalador() {
    bind_descargar
    bind_preconfiguracion
    bind_instalar

    echo -e "$VE ¿Quieres el configurar de forma$RO interactiva$VE Bind9?$CL"
    read -p ' s/N → ' input
    if [[ "$input" == 's' ]] || [[ "$input" == 'S' ]]; then
        bind_postconfiguracion
    fi

    ## Reiniciar servidor BIND para aplicar configuración
    reiniciarServicio bind
}
