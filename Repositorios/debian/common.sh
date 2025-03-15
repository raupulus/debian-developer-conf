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
## Este script agrega repositorios comunes para todas las ramas.

###########################
##       FUNCIONES       ##
###########################
##
## Añade llaves oficiales para cada repositorio común
##
common_add_key() {
    ## Multisystem (Problema en descargar clave, nunca responde su servidor para el .asc)
    #echo -e "$VE Agregando clave para$RO Multisystem$CL"
    #wget -q -O - http://liveusb.info/multisystem/depot/multisystem.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/multisystem.gpg > /dev/null

    ## Kali Linux
    echo -e "$VE Agregando clave para$RO Kali Linux$CL"
    sudo curl -fsSL https://archive.kali.org/archive-key.asc | sudo gpg --dearmor  -o /usr/share/keyrings/kali-archive-key.gpg && sudo chmod go+r /usr/share/keyrings/kali-archive-key.gpg

    ## Repositorio para Balena Etcher
    echo -e "$VE Agregando clave para$RO Etcher$CL"
    sudo curl -fsSL https://dl.cloudsmith.io/public/balena/etcher/gpg.70528471AFF9A051.key | sudo gpg --dearmor  -o /usr/share/keyrings/balena-etcher.gpg && sudo chmod go+r /usr/share/keyrings/balena-etcher.gpg

    ## Repositorio para editor DBeaver.
    echo -e "$VE Agregando clave para el editor SQL$RO DBeaver$CL"
    sudo curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --dearmor  -o /usr/share/keyrings/dbeaver.gpg && sudo chmod go+r /usr/share/keyrings/dbeaver.gpg

    ## Vscode
    echo -e "$VE Agregando clave para el editor $RO VsCode$CL"
    sudo wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor  > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo rm -f packages.microsoft.gpg
    sudo chmod ugo+r /etc/apt/sources.list.d/vscode.list

    ## Repositorio para editor VS Codium.
    echo -e "$VE Agregando clave para el editor$RO VS Codium$CL"
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor  | sudo dd of=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg
    sudo chmod ugo+r /etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg
    #sudo touch /etc/apt/apt.conf.d/99verify-peer.conf
    #echo "Acquire { https::Verify-Peer false }" | sudo tee /etc/apt/apt.conf.d/99verify-peer.conf

    ## Any Desk
    echo -e "$VE Agregando clave para $RO Any Desk$CL"
    sudo curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /etc/apt/keyrings/keys.anydesk.com.gpg && sudo chmod go+r /etc/apt/keyrings/keys.anydesk.com.gpg

    ## Beekeeper Studio (Gestionar Bases de Datos)
    echo -e "$VE Agregando clave para $RO Beekeeper Studio$CL"
    #wget --quiet -O - https://deb.beekeeperstudio.io/beekeeper.key | sudo apt-key add -
    curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key | sudo gpg --dearmor -o /usr/share/keyrings/beekeeper.gpg && sudo chmod go+r /usr/share/keyrings/beekeeper.gpg

    ## QOwnNotes
    echo -e "$VE Agregando clave para $RO QOwnNotes$CL"
    curl -fsSL http://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Debian_12/Release.key | gpg --dearmor  | sudo tee /etc/apt/keyrings/qownnotes.gpg > /dev/null && sudo chmod u=rw,go=r /etc/apt/keyrings/qownnotes.gpg

    ## Stripe
    curl -s https://packages.stripe.dev/api/security/keypair/stripe-cli-gpg/public | gpg --dearmor  | sudo tee /usr/share/keyrings/stripe.gpg && sudo chmod u=rw,go=r /usr/share/keyrings/stripe.gpg
}

##
## Agrega los repositorios desde su directorio "comunes"
##
common_sources_repositories() {
    echo -e "$VE Añadido$RO sources.list$VE y$RO sources.list.d/$VE Agregados$CL"

    if [[ ! -d '/etc/apt/sources.list.d' ]]; then
        sudo mkdir -p '/etc/apt/sources.list.d'
    fi

    sudo cp $WORKSCRIPT/Repositorios/debian/comunes/sources.list.d/* /etc/apt/sources.list.d/
}

##
## Instala repositorios que son descargados mediante un script oficial
##
common_download_repositories() {
    echo -e "$VE Descargando repositorios desde scripts oficiales$CL"
}

##
## Añade todos los repositorios y llaves
##
common_add_repositories() {
    echo -e "$VE Instalando repositorios$RO Comunes$CL"
    common_sources_repositories
    common_download_repositories
    echo -e "$VE Actualizando antes de obtener las llaves, es normal que se muestren errores$AM (Serán solucionados en el próximo paso)$CL"
    actualizarRepositorios
    common_add_key
    echo -e "$VE Actualizando listas de repositorios definitiva, comprueba que no hay$RO errores$CL"
    actualizarRepositorios
}
