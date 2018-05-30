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

    while [[ "$dominio" == '' ]]; do
        clear
        echo -e "$AM Introduce el nombre de$RO dominio:$CL"
        read -p 'Dominio → ' dominio
    done

    while [[ "$ipzona" == '' ]]; do
        clear
        echo -e "$AM Introduce la$RO IP$VE:$CL"
        read -p 'IP → ' ipzona
    done

    while [[ "$ipzonainv" == '' ]]; do
        clear
        echo -e "$AM Introduce los bloques red con esa parte de la$RO IP$VE al$RO revés$VE (1.168.192 o 18.172):$CL"
        read -p 'IP → ' ipzonainv
    done

    echo -e "$VE ¿Quieres limpiar configuraciones anteriores?$CL"
    echo -e "$VE Elegir$RO SI$VE puede$RO Borrar$VE configuraciones"
    read -p ' s/N → ' input
    if [[ "$input" == 's' ]] || [[ "$input" == 'S' ]]; then
        echo '' | sudo tee '/etc/bind/named.conf.local'
    fi

    echo -e "$VE Creando zonas:$RO directa$VE e$RO inversa$CL"

    ## Creando Zona Directa:
    sudo cp '/etc/bind/db.local' "/etc/bind/db.${dominio}"
    echo "zone \"$dominio\" {" | sudo tee -a '/etc/bind/named.conf.local'
    echo "    type ${zona};" | sudo tee -a '/etc/bind/named.conf.local'
    echo "    //also-notify \{192.168.1.2\};" | sudo tee -a '/etc/bind/named.conf.local'
    echo "    file \"/etc/bind/db.${dominio}\";" | sudo tee -a '/etc/bind/named.conf.local'
    echo '};'

    ## Creando Zona Inversa:
    sudo cp '/etc/bind/db.127' "/etc/bind/db.${ipzonainv}.rev"
    echo "zone \"${ipzonainv}.in-addr.arpa\" {" | sudo tee -a '/etc/bind/named.conf.local'
    echo "    type ${zona};" | sudo tee -a '/etc/bind/named.conf.local'
    echo "    //also-notify \{192.168.1.2\};" | sudo tee -a '/etc/bind/named.conf.local'
    echo "    file \"/etc/bind/db.${ipzonainv}.rev\";" | sudo tee -a '/etc/bind/named.conf.local'
    echo '};'

    ## Reenviadores
    echo -e "$VE Configurando$RO reenviadores$CL"
    local optns='/etc/bind/named.conf.options'
    echo "options {" | sudo tee "$optns"
    echo "        directory \"/var/cache/bind\";" | sudo tee -a "$optns"
    echo "        forwarders {" | sudo tee -a "$optns"
    echo "            $reenviador1;" | sudo tee -a "$optns"
    echo "            $reenviador2;" | sudo tee -a "$optns"
    echo "        };" | sudo tee -a "$optns"
    echo "" | sudo tee -a "$optns"
    echo "        dnssec-validation auto;" | sudo tee -a "$optns"
    echo "" | sudo tee -a "$optns"
    echo "        auth-nxdomain no;    # conform to RFC1035" | sudo tee -a "$optns"
    echo "        listen-on-v6 { any; };" | sudo tee -a "$optns"
    echo "};" | sudo tee -a "$optns"

    ## Configurar zona directa
    local dbzona="/etc/bind/db.$dominio"
    echo -e "$VE Configurando$RO Zona Directa$CL"
    sudo sed -i "s/root.localhost/${dominio}/" "$dbzona"
    sudo sed -i "s/localhost/${dominio}/" "$dbzona"
    sudo sed -i "s/127.0.0.1/$ipzona/" "$dbzona"
    sudo sed -r -i "s/^@\s*IN\sA\s*127.0.0.1.*$/${dominio} IN A 127.0.0.1/" "$dbzona"

    ## Configurar zona inversa
    local dbzonainv="/etc/bind/db.${ipzonainv}.rev"
    echo -e "$VE Configurando$RO Zona Inversa$CL"
    sudo sudo sed -i "s/root.localhost/$dominio/" "$dbzonainv"
    sudo sudo sed -i "s/localhost/$dominio/" "$dbzonainv"
    sudo sed -i "s/1.0.0/$ipzonainv/" "$dbzonainv"

    sudo nano "$dbzona"
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
    reiniciarServicio bind9
}
