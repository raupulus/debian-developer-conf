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

###########################
##       FUNCIONES       ##
###########################
##
## Agregar Archivos de configuración al home
##
agregar_conf_home() {
    echo -e "$VE Preparando para añadir$RO archivos de configuración$VE en el home de usuario$CL"
}

##
## Asigna permisos en el home de usuario poco permisivos donde el propietario
## tiene todos los permisos, el grupo lectura y ejecución y otros nada.
## Además asigna la máscara (umask) para esto por defecto.
##
permisos() {
    echo -e "$VE Estableciendo permisos en el sistema$CL"
    ## TODO → Permisos en home de usuario poco permisivos
}

##
## Establecer programas por defecto
##
programas_default() {
    echo -e "$VE Estableciendo programas por defecto$CL"

    ## TERMINAL
    if [[ -f /usr/bin/tilix ]]; then
        echo -e "$VE Estableciendo terminal por defecto a$RO Tilix$CL"
        sudo touch /etc/profile.d/vte.sh 2>> /dev/null
        sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper 2>> /dev/null
    elif [[ -f '/usr/bin/terminator' ]]; then
        echo -e "$VE Estableciendo terminal por defecto a$RO Terminator$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/terminator
    elif [[ -f '/usr/bin/sakura' ]]; then
        echo -e "$VE Estableciendo terminal por defecto a$RO Sakura$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/sakura
    else
        echo -e "$VE Estableciendo terminal por defecto a$RO XTerm$CL"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/xterm
    fi

    ## Navegador
    if [[ -f '/usr/bin/firefox-esr' ]]; then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Firefox-ESR$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/firefox-esr
        sudo update-alternatives --set gnome-www-browser /user/bin/firefox-esr 2>> /dev/null
    elif [[ -f '/usr/bin/firefox' ]]; then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Firefox$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/firefox
        sudo update-alternatives --set gnome-www-browser /user/bin/firefox 2>> /dev/null
    elif [[ -f '/usr/bin/chromium' ]]; then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO Chromium$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/chromium
        sudo update-alternatives --set gnome-www-browser /user/bin/chromium 2>> /dev/null
    elif [[ -f '/usr/bin/chrome' ]]; then
        echo -e "$VE Estableciendo Navegador WEB por defecto a$RO chrome$CL"
        sudo update-alternatives --set x-www-browser /usr/bin/chrome
        sudo update-alternatives --set gnome-www-browser /user/bin/chrome 2>> /dev/null
    fi

    ## Editor de texto terminal
    if [[ -f '/usr/bin/vim.gtk3' ]]; then
        echo -e "$VE Estableciendo Editor por defecto a$RO Vim GTK3$CL"
        sudo update-alternatives --set editor /usr/bin/vim.gtk3
    elif [[ -f '/usr/bin/vim' ]]; then
        echo -e "$VE Estableciendo Editor WEB por defecto a$RO Vim$CL"
        sudo update-alternatives --set editor /usr/bin/vim
    elif [[ -f '/bin/nano' ]]; then
        echo -e "$VE Estableciendo Editor WEB por defecto a$RO Nano$CL"
        sudo update-alternatives --set editor /bin/nano
    fi

    ## Editor de texto con GUI
    if [[ -f '/usr/bin/gedit' ]]; then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Gedit$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/gedit
    elif [[ -f '/usr/bin/kate' ]]; then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Kate$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/kate
    elif [[ -f '/usr/bin/leafpad' ]]; then
        echo -e "$VE Estableciendo Editor GUI por defecto a$RO Leafpad$CL"
        sudo update-alternatives --set gnome-text-editor /usr/bin/leafpad
    fi
}

##
## Elegir intérprete de comandos entre los actuales instalados del sistema
##
terminal() {
    ## TODO → Comprobar si solo está bash instalado, no pregunta.
    while true; do
        echo -e "$VE Selecciona a continuación el$RO terminal$VE a usar$CL"
        echo -e "$VE Tenga en cuenta que este script está optimizado para$RO bash$CL"
        echo -e "$RO 1)$VE bash$CL"
        echo -e "$RO 2)$VE zsh$CL"
        read -p "Introduce el terminal → bash/zsh: " term
        case "$term" in
            bash | 1)  ## Establecer bash como terminal
                chsh -s /bin/bash
                ## Cambiar enlace por defecto desde sh a bash
                sudo rm /bin/sh
                sudo ln -s /bin/bash /bin/sh
                break;;
            zsh | 2)  ## Establecer zsh como terminal
                chsh -s /bin/zsh
                ## Cambiar enlace por defecto desde sh a zsh
                sudo rm /bin/sh
                sudo ln -s /bin/zsh /bin/sh
                break;;
            *)  ## Opción errónea
                echo -e "$RO Opción no válida$CL"
        esac
    done
}

##
## Configurar editor de gnome, gedit
##
configurar_gedit() {
    if [[ ! -d "$HOME/.local/share" ]]; then
        mkdir -p "$HOME/.local/share/" 2>> /dev/null
    fi

    cp -r ./gedit/.local/share/* "$HOME/.local/share/"

    mkdir -p "$HOME/.config/gedit/" 2>> /dev/null
    cp -r ./gedit/.config/gedit/* "$HOME/.config/gedit/"
}

##
## Configurar editor de terminal, nano
##
configurar_nano() {
    echo -e "$VE Configurando editor$RO nano$CL"

    if [[ -d "$HOME/.nano" ]] &&
       [[ ! -d "$HOME/.nano/.git" ]]
    then
        crearBackup '.nano'
        rm -Rf "$HOME/.nano"
    fi

    ## Clona el repositorio o actualizarlo si ya existe
    if [[ -d "$HOME/.nano/.git" ]]; then
        ## Actualizar Repositorio con git pull
        cd "$HOME/.nano"
        echo -e "$VE Actualizando repositorios$RO $HOME/.nano/.git$CL"
        git pull
        cd "$WORKSCRIPT"
    else
        git clone 'https://github.com/scopatz/nanorc.git' "$HOME/.nano"
    fi

    ## Habilita syntaxis para el usuario
    cat "$HOME/.nano/nanorc" >> "$HOME/.nanorc"
}

##
## Crea un archivo hosts muy completo que bloquea bastantes
## sitios malignos en la web evitando riesgos y mejorando navegabilidad
##
configurar_hosts() {
    echo -e "$VE Configurar archivo$RO /etc/hosts$CL"

    ## Crea copia del original para mantenerlo siempre
    if [[ ! -f '/etc/hosts.BACKUP' ]]; then
        sudo mv '/etc/hosts' '/etc/hosts.BACKUP'
    fi

    if [[ -f '/etc/hosts.BACKUP' ]]; then
        sudo cat '/etc/hosts.BACKUP' > "$WORKSCRIPT/tmp/hosts"
        cat "$WORKSCRIPT/conf/etc/hosts" >> "$WORKSCRIPT/tmp/hosts"
        sudo cp "$WORKSCRIPT/tmp/hosts" '/etc/hosts'
    else
        echo -e "$VE Existe algún problema con el archivo$RO /etc/hosts$CL"
        echo -e "$VE Te recomiendo revisar esto manualmente$CL"
    fi
}

##
## Añadir plantillas Genéricas
##
agregar_plantillas() {
    crearBackup "$HOME/Plantillas"
    enlazarHome 'Plantillas/Genéricas'
}

##
## Personaliza terminal tilix
##
tilix_personalizar() {
    ## TODO → Comprobar si existe instalado cada tema

    if [[ ! -d "$HOME/.config/tilix/schemes/" ]]; then
        echo -e "$VE Creando directorio $HOME/.config/tilix/schemes/$CL"
        mkdir -p "$HOME/.config/tilix/schemes/"
    fi

    wget -qO $HOME"/.config/tilix/schemes/3024-night.json" https://git.io/v7QVY
    wget -qO $HOME"/.config/tilix/schemes/dimmed-monokai.json" https://git.io/v7QaJ
    wget -qO $HOME"/.config/tilix/schemes/monokai.json" https://git.io/v7Qad
    wget -qO $HOME"/.config/tilix/schemes/monokai-soda.json" https://git.io/v7Qao
    wget -qO $HOME"/.config/tilix/schemes/molokai.json" https://git.io/v7QVE
    wget -qO $HOME"/.config/tilix/schemes/cobalt2.json" https://git.io/v7Qav
    wget -qO $HOME"/.config/tilix/schemes/dracula.json" https://git.io/v7QaT
}

##
## Instalar Todas las configuraciones
##
instalar_configuraciones() {
    permisos
    programas_default

    cd "$WORKSCRIPT"

    configurar_gedit
    configurar_nano
    agregar_conf_home
    configurar_hosts
    agregar_plantillas
    terminal ## Pregunta el terminal a usar

    sudo update-command-not-found >> /dev/null 2>> /dev/null
}
