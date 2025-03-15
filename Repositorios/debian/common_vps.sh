#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2021 Raúl Caro Pastorino
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
## Add commons repositories to all debian versions and vps.

###########################
##       FUNCIONES       ##
###########################
##
## Añade llaves oficiales para cada repositorio común
##
common_vps_add_keys() {
    ## Agregando llave para Gitlab Runner.
    echo -e "$VE Agregando llave para$RO Gitlab Runner$CL"
    curl -L "https://packages.gitlab.com/runner/gitlab-runner/gpgkey" 2> /dev/null | sudo apt-key add - &>/dev/null

    ## Docker
    echo -e "$VE Agregando clave para$RO Docker$CL"
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys F76221572C52609D

    ## Heroku
    echo -e "$VE Agregando clave para$RO Heroku$CL"
    curl -fsSL https://cli-assets.heroku.com/channels/stable/apt/release.key | gpg --dearmor  | sudo tee /usr/share/keyrings/heroku.gpg >/dev/null && sudo chmod go+r /usr/share/keyrings/heroku.gpg

    ## Mi propio repositorio en launchpad
    echo -e "$VE Agregando clave para$RO Fryntiz Repositorio$CL"
    gpg --keyserver keyserver.ubuntu.com --recv-key B5C6D9592512B8CD && gpg -a --export $PUBKRY | sudo apt-key add -

    ## Repositorio de PostgreSQL Oficial
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

    ## Debian Multimedia
    instalarSoftware deb-multimedia-keyring

    ## Repositorio para Tor oficial y estable
    echo -e "$VE Agregando clave para$RO Tor Repositorio$CL"
    wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor  | sudo tee /usr/share/keyrings/deb.torproject.org-keyring.gpg >/dev/null && sudo chmod go+r /usr/share/keyrings/deb.torproject.org-keyring.gpg
    actualizarRepositorios
    instalarSoftware 'deb.torproject.org-keyring' 'apt-transport-tor'

    ## GO CD (Desarrollo continuo)
    echo -e "$VE Agregando clave para $RO GO CD$CL"
    curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo gpg --dearmor  -o /usr/share/keyrings/gocd.gpg && sudo chmod a+r /usr/share/keyrings/gocd.gpg

    ## MongoDB
    echo -e "$VE Agregando clave para $RO MongoDB$CL"
    curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor && sudo chmod go+r /usr/share/keyrings/mongodb-server-8.0.gpg

    ## Sury (Paquetes PHP)
    echo -e "$VE Agregando llave para$RO PHP$VE de sury,org$CL"
    sudo curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb
    sudo dpkg -i /tmp/debsuryorg-archive-keyring.deb
}

##
## Instala repositorios que son descargados mediante un script oficial
##
common_vps_download_repositories() {
    echo -e "$VE Descargando repositorios desde scripts oficiales$CL"
    ## NodeJS Oficial
    echo -e "$VE Agregando repositorio$RO NodeJS$AM Repositorio Oficial$CL"
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo chmod ugo+r /etc/apt/sources.list.d/nodesource.list /etc/apt/preferences.d/nodejs /etc/apt/preferences.d/nsolid

    ## Sury (Paquetes PHP)
    echo -e "$VE Agregando repositorio$RO Sury$AM Repositorio Oficial$CL"
    sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'

    ## Webmin
    curl -o /tmp/webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh && sudo sh /tmp/webmin-setup-repo.sh
    sudo chmod go+r /usr/share/keyrings/debian-webmin-developers.gpg
    sudo chmod ugo+r /etc/apt/sources.list.d/webmin-stable.list
}

##
## Añade todos los repositorios y llaves
##
common_vps_add_repositories() {
    echo -e "$VE Instalando repositorios$RO Comunes con los VPS$CL"
    common_vps_download_repositories
    echo -e "$VE Actualizando antes de obtener las llaves, es normal que se muestren errores$AM (Serán solucionados en el próximo paso)$CL"
    actualizarRepositorios
    common_vps_add_keys
    echo -e "$VE Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    actualizarRepositorios
}
