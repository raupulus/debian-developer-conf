#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-

mainFirewall() {
    enableFirewalldAndConfigure() {
        ## Comprobar que existe firewall-cmd

        ## Inicio ahora el cortafuegos
        sudo systemctl start firewalld

        ## Habilito Cortafuegos al iniciar
        sudo systemctl enable firewalld

        #sudo firewall-cmd --set-default-zone=dmz
        #sudo firewall-cmd --zone=dmz --add-interface=eth0

        ## Permito ssh
        sudo firewall-cmd --zone=public --add-service=ssh --permanent
        sudo firewall-cmd --zone=public --add-service=ssh

        ## Permito http
        sudo firewall-cmd --zone=public --add-service=http --permanent
        sudo firewall-cmd --zone=public --add-service=http

        ## Permito https
        sudo firewall-cmd --zone=public --add-service=https --permanent
        sudo firewall-cmd --zone=public --add-service=https

        ## Permito PostgreSQL
        sudo firewall-cmd --zone=public --add-service=postgresql --permanent
        sudo firewall-cmd --zone=public --add-service=postgresql

        ## Permito ISPConfig
        #sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
        #sudo firewall-cmd --zone=public --add-port=8080/tcp

        ## Permito mumble
        #sudo firewall-cmd --zone=public --add-port=64738/tcp --permanent
        #sudo firewall-cmd --zone=public --add-port=64738/tcp
        #sudo firewall-cmd --zone=public --add-port=64738/udp --permanent
        #sudo firewall-cmd --zone=public --add-port=64738/udp

        ## Permito VPN
        #sudo firewall-cmd --zone=public --add-port=1194/udp --permanent
        #sudo firewall-cmd --zone=public --add-port=1194/udp

        ## Permito DNS
        #sudo firewall-cmd --zone=public --add-service=dns --permanent
        #sudo firewall-cmd --zone=public --add-service=dns
        #sudo firewall-cmd --zone=public --add-service=dns-over-tls --permanent
        #sudo firewall-cmd --zone=public --add-service=dns-over-tls

        ## Permito FTP
        #sudo firewall-cmd --zone=public --add-service=ftp --permanent
        #sudo firewall-cmd --zone=public --add-service=ftp

        ## Permito MONGODB
        sudo firewall-cmd --zone=public --add-service=mongodb --permanent
        sudo firewall-cmd --zone=public --add-service=mongodb

        ## Permito MySQL
        sudo firewall-cmd --zone=public --add-service=mysql --permanent
        sudo firewall-cmd --zone=public --add-service=mysql
    }

    ## TOFIX → Los servidores pueden dar problemas al configurar por ssh.
    if [[ -f '/usr/bin/nohup' ]]; then
        #nohup enableFirewalldAndConfigure > firewallConfigLog.out &
        enableFirewalldAndConfigure
        echo -e "$VE Esperando a terminar de configurar Firewall$CL"
        #sleep 20
    else
        enableFirewalldAndConfigure
    fi

    ## Recargo cortafuegos
    #sudo firewall-cmd --reload



    #Otros servicios (sudo firewall-cmd --get-services)

    #docker-registry
    #docker-swarm
    #dropbox-lansync
    #git
    #imap
    #imaps
    #pop3
    #pop3s
    #redis
    #redis-sentinel
    #rsyncd
    #smtp
    #smtp-submission
    #smtps
}
