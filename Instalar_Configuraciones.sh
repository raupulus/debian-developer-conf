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
##     IMPORTACIONES      ##
############################

###########################
##       FUNCIONES       ##
###########################
## Agregar Archivos de configuración al home
agregar_conf_home() {
    echo -e "$VE Preparando para añadir archivos de configuración en el home de usuario$CL"
}

## Permisos
permisos() {
    echo -e "$VE Estableciendo permisos en el sistema$CL"
    ## TODO → Permisos en home de usuario poco permisivos
}

## Establecer programas por defecto
programas_default() {
    echo -e "$VE Estableciendo programas por defecto$CL"

    ## TERMINAl
    if [ -f /usr/bin/tilix ]
    then
        echo -e "$VE Estableciendo terminal por defecto a$RO Tilix$CL"
        sudo touch /etc/profile.d/vte.sh 2>> /dev/null
        sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper 2>> /dev/null
    elif [ -f /usr/bin/terminator ]
    then
        echo -e "$VE Estableciendo terminal por defecto a$RO Terminator$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/terminator
    elif [ -f /usr/bin/sakura ]
    then
        echo -e "$VE Estableciendo terminal por defecto a$RO Sakura$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/sakura
    else
        echo -e "$VE Estableciendo terminal por defecto a$RO XTerm$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/xterm
    fi

    #Navegador
    if [ -f /usr/bin/firefox-esr ]
    then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Firefox-ESR$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/firefox-esr
        sudo update-alternatives --set gnome-www-browser /user/bin/firefox-esr 2>> /dev/null
    elif [ -f /usr/bin/firefox ]
    then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Firefox$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/firefox
        sudo update-alternatives --set gnome-www-browser /user/bin/firefox 2>> /dev/null
    elif [ -f /usr/bin/chromium ]
    then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Chromium$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/chromium
        sudo update-alternatives --set gnome-www-browser /user/bin/chromium 2>> /dev/null
    elif [ -f /usr/bin/chrome ]
    then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO chrome$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/chrome
        sudo update-alternatives --set gnome-www-browser /user/bin/chrome 2>> /dev/null
    fi

    #Editor de texto terminal
    if [ -f /usr/bin/vim.gtk3 ]
    then
        echo -e "$VE Estableciendo Editor por defecto a$RO Vim GTK3$CL"
        sudo update-alternatives --set editor /usr/bin/vim.gtk3
    elif [ -f /usr/bin/vim ]
    then
        echo -e "$VE Estableciendo Editor WEB por defecto a$RO Vim$CL"
        sudo update-alternatives --set editor /usr/bin/vim
    elif [ -f /bin/nano ]
    then
        echo -e "$VE Estableciendo Editor WEB por defecto a$RO Nano$CL"
        sudo update-alternatives --set editor /bin/nano
    fi

    #Editor de texto con GUI
    if [ -f /usr/bin/gedit ]
    then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Gedit$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/gedit
    elif [ -f /usr/bin/kate ]
    then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Kate$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/kate
    elif [ -f /usr/bin/leafpad ]
    then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Leafpad$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/leafpad
    fi
}

#Elegir intérprete de comandos
function terminal() {
    while true
    do
        echo -e "$VE Selecciona a continuación el$RO terminal$VE a usar$CL"
        echo -e "$VE Tenga en cuenta que este script está optimizado para$RO bash$CL"
        echo -e "$VE 1) bash$CL"
        echo -e "$VE 2) zsh$CL"
        read -p "Introduce el terminal → bash/zsh: " term
        case $term in
            bash | 1)#Establecer bash como terminal
                chsh -s /bin/bash
                # Cambiar enlace por defecto desde sh a bash
                sudo rm /bin/sh
                sudo ln -s /bin/bash /bin/sh
                break;;
            zsh | 2)#Establecer zsh como terminal
                chsh -s /bin/zsh
                # Cambiar enlace por defecto desde sh a zsh
                sudo rm /bin/sh
                sudo ln -s /bin/zsh /bin/sh
                break;;
            *)#Opción errónea
                echo -e "$RO Opción no válida$CL"
        esac
    done
}

# Configurar editor de gnome, gedit
function configurar_gedit() {
    mkdir -p ~/.local/share/ 2>> /dev/null
    cp -r ./gedit/.local/share/* ~/.local/share/

    mkdir -p ~/.config/gedit/ 2>> /dev/null
    cp -r ./gedit/.config/gedit/* ~/.config/gedit/
}

# Configurar editor de terminal, nano
function configurar_nano() {
    echo -e "$VE Configurando editor nano$CL"

    if [ -d ~/.nano ]
    then
        mv ~/.nano ~/.nanoBACKUP
    fi

    # Clona el repositorio o actualizarlo si ya existe
    if [ -d ~/.nano/.git ]
    then
        # Actualizar Repositorio con git pull
        dir_actual=`echo $PWD`
        cd ~/.nano
        git pull
        cd $dir_actual
    else
        git clone https://github.com/scopatz/nanorc.git ~/.nano
    fi

    # Habilita syntaxis para el usuario
    cat ~/.nano/nanorc >> ~/.nanorc
}

#Crea un archivo hosts muy completo que bloquea bastantes sitios malignos en la web
function configurar_hosts() {
    echo -e "$VE Configurar archivo$RO /etc/hosts"

    # Crea copia del original para mantenerlo siempre
    if [ ! -f /etc/hosts.BACKUP ]
    then
        sudo mv /etc/hosts /etc/hosts.BACKUP 2>> /dev/null
    fi

    sudo cat /etc/hosts.BACKUP > ./TMP/hosts 2>> /dev/null
    cat ./etc/hosts >> ./TMP/hosts 2>> /dev/null
    sudo cp ./TMP/hosts /etc/hosts 2>> /dev/null
}

# Añadir plantillas
function agregar_plantillas() {
    if [ -d ~/Plantillas ]
    then
        cp -R ./Plantillas/* ~/Plantillas/
    else
        mkdir ~/Plantillas
        cp -R ./Plantillas/* ~/Plantillas/
    fi
}

function tilix_personalizar() {
    # TODO → Comprobar si existe instalado cada tema
    mkdir -p /home/alumno/.config/tilix/schemes/ 2>> /dev/null
    wget -qO $HOME"/.config/tilix/schemes/3024-night.json" https://git.io/v7QVY
    wget -qO $HOME"/.config/tilix/schemes/dimmed-monokai.json" https://git.io/v7QaJ
    wget -qO $HOME"/.config/tilix/schemes/monokai.json" https://git.io/v7Qad
    wget -qO $HOME"/.config/tilix/schemes/monokai-soda.json" https://git.io/v7Qao
    wget -qO $HOME"/.config/tilix/schemes/molokai.json" https://git.io/v7QVE
    wget -qO $HOME"/.config/tilix/schemes/cobalt2.json" https://git.io/v7Qav
    wget -qO $HOME"/.config/tilix/schemes/dracula.json" https://git.io/v7QaT
}

# Instalar Todas las configuraciones
function instalar_configuraciones() {
    permisos
    programas_default

    cd $DIR_SCRIPT

    configurar_gedit
    configurar_nano
    agregar_conf_home
    configurar_vim
    configurar_hosts
    agregar_plantillas
    terminal #Pregunta el terminal a usar

    sudo update-command-not-found >> /dev/null 2>> /dev/null
}
