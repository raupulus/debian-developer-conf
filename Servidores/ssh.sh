#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2018 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Guía de estilos aplicada:
## @style      https://gitlab.com/fryntiz/bash-guide-style

############################
##     INSTRUCCIONES      ##
############################

ssh_descargar() {
    echo -e "$VE Descargando$RO ssh$CL"
}

ssh_preconfiguracion() {
    echo -e "$VE Generando Pre-Configuraciones de$RO ssh$CL"
}

ssh_instalar() {
    echo -e "$VE Instalando$RO ssh$CL"
    instalarSoftwareLista "${SOFTLIST}/Servidores/ssh.lst"
}

ssh_postconfiguracion() {
    echo -e "$VE Generando Post-Configuraciones de$RO ssh$CL"
    local sshd='/etc/ssh/sshd_config'

    if [[ -f '/etc/ssh/sshd_config' ]]; then
        ## Inactividad → 30 minutos, pregunta 3 veces (cada 10 minutos)
        sudo sed -r -i "s/^#?\s*ClientAliveInterval.*$/ClientAliveInterval 36000/" $sshd
        sudo sed -r -i "s/^#?\s*ClientAliveCountMax.*$/ClientAliveCountMax 3/" $sshd
        sudo sed -r -i "s/^#?\s*TCPKeepAlive.*$/TCPKeepAlive yes/" $sshd

        ## Reenvío de X11
        sudo sed -r -i "s/^#?\s*X11Forwarding.*$/X11Forwarding yes/" $sshd

        ## Puerto
        sudo sed -r -i "s/^#?\s*Port.*$/Port 22/" $sshd

        ## No permitir root login
        sudo sed -r -i "s/^#?\s*PermitRootLogin.*$/PermitRootLogin no/" $sshd

        ## No permitir claves vacías
        sudo sed -r -i "s/^#?\s*PermitEmptyPasswords.*$/PermitEmptyPasswords no/" $sshd
    fi

    ## Configuro mensajes de bienvenida
    ## /etc/issue -> Mensaje de login para acceso local al equipo (Acceso por TTY)
    ## /etc/issue.net -> Mensaje de login para acceso por red (Acceso por SSH)
    ## /etc/motd -> Mensaje para después del login.
    echo "$DISTRO by Fryntiz → raul@fryntiz.dev" | sudo tee '/etc/issue'
    echo "$DISTRO by Fryntiz → raul@fryntiz.dev" | sudo tee '/etc/issue.net'
    echo "Has conectado al servidor $DISTRO mantenido por → raul@fryntiz.dev" | sudo tee '/etc/motd'
}

ssh_instalador() {
    ssh_descargar
    ssh_preconfiguracion
    ssh_instalar
    ssh_postconfiguracion
}
