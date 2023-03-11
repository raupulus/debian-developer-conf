#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @gitlab     https://gitlab.com/raupulus
## @github     https://github.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

############################
##      INSTRUCTIONS      ##
############################
##

############################
##        FUNCTIONS       ##
############################

fail2ban_descargar() {
    echo -e "$VE Descargando$RO fail2ban$CL"
}

fail2ban_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO fail2ban"
}

fail2ban_instalar() {
    echo -e "$VE Instalando$RO fail2ban$CL"
    local software='fail2ban'
    instalarSoftware "$software"
}

fail2ban_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de fail2ban$CL"
    if [[ ! -f '/etc/fail2ban/jail.local' ]]; then
        sudo cp '/etc/fail2ban/jail.conf' '/etc/fail2ban/jail.local'
    fi
}

fail2ban_instalador() {
    fail2ban_descargar
    fail2ban_preconfiguracion
    fail2ban_instalar

    ## Reiniciar fail2ban para aplicar configuración
    reiniciarServicio fail2ban
    sudo systemctl status fail2ban
    sudo fail2ban-client ping
}
