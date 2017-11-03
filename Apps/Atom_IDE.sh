#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

#############################
##   Variables Generales   ##
#############################
atom=$(cat Atom_Paquetes.lst) #Instala Paquetes de Atom

function configurar_atom() {
    echo -e "$verde Añadiendo configuraciones para Atom"

    echo -e "$verde Deshabilitando complementos"
    apm disable welcome
    apm disable about

    # TODO → Añadir configuración de idiomas
    # echo '
    # "atom-i18n":
    #   customMenuI18nPath: "$HOME/.atom/packages/atom-i18n/def/custom_menu.cson"
    #   locale: "es"
    # '
}

#Instala complementos para Atom IDE
function atom_install() {
    if [ -f /usr/bin/atom ]
    then
        echo -e "$verde Ya esta$rojo ATOM$verde instalado en el equipo, omitiendo paso$gris"
    else
        REINTENTOS=3
        echo -e "$verde Descargando$rojo ATOM$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm deb atom.deb 2>> /dev/null
            wget https://atom.io/download/deb && mv deb atom.deb && break
        done
        echo -e "$verde Instalando$rojo Atom $gris"
        sudo dpkg -i atom.deb && sudo apt install -f -y
    fi

    # Si se ha instalado correctamente ATOM pues instalamos sus plugins
    echo -e "$verde Preparando instalación complementos$rojo Atom$gris"
    if [ -f /usr/bin/atom ]
    then
        for p in $atom
        do
            # Comprobación si existe instalado el complemento
            if [ -d "$HOME/.atom/packages/$p" ]
            then
                echo -e "$amarillo Ya se encuentra instalado →$rojo $p"
            else
                echo -e "$verde Instalando$rojo $p $amarillo"
                apm install $p
            fi
        done
    fi

    configurar_atom
}
