#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#######################################
# ###     Raúl Caro Pastorino     ### #
## ##                             ## ##
### # https://github.com/fryntiz/ # ###
## ##                             ## ##
# ###       www.fryntiz.es        ### #
#######################################

############################
##   Constantes Colores   ##
############################
amarillo="\033[1;33m"
azul="\033[1;34m"
blanco="\033[1;37m"
cyan="\033[1;36m"
gris="\033[0;37m"
magenta="\033[1;35m"
rojo="\033[1;31m"
verde="\033[1;32m"

#############################
##   Variables Generales   ##
#############################

#Instala el script de OhMyZSH
function ohMyZSH() {
    if [ -f ~/.oh-my-zsh/oh-my-zsh.sh ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo OhMyZSH$verde instalado para este usuario, omitiendo paso$gris"
    else
        REINTENTOS=5
        echo -e "$verde Descargando OhMyZSH$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            ###TOFIX → Reparar script que sale mal: contraseña PAM y error (no continua por eso)
            rm -R ~/.oh-my-zsh 2>> /dev/null
            curl -L http://install.ohmyz.sh | sh && break || break
        done
    fi
}

function bashit() {
    if [ -f ~/.bash_it/bash_it.sh ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo Bash-It$verde instalado para este usuario, omitiendo paso$gris"
        bash ~/.bash_it/install.sh --silent 2>> /dev/null
    else
        REINTENTOS=5

        echo -e "$verde Descargando Bash-It$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm -R ~/.bash_it 2>> /dev/null
            git clone https://github.com/Bash-it/bash-it.git ~/.bash_it && bash ~/.bash_it/install.sh --silent && break
        done
    fi

    if [ -f ~/.nvm/nvm.sh ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo nvm$verde instalado para este usuario, omitiendo paso$gris"
    else
        REINTENTOS=5
        echo -e "$verde Descargando nvm$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            rm -R ~/.nvm 2>> /dev/null
            git clone https://github.com/creationix/nvm.git ~/.nvm && ~/.nvm/install.sh && break
        done
    fi

    if [ -f ~/fasd/fasd.1.md ] #Comprobar si ya esta instalado
    then
        echo -e "$verde Ya esta$rojo fasd$verde instalado para este usuario, omitiendo paso$gris"
    else
        REINTENTOS=5

        echo -e "$verde Descargando fasd$gris"
        for (( i=1; i<=$REINTENTOS; i++ ))
        do
            tmp=$pwd
            rm -R -f "~/fasd" 2>> /dev/null
            git clone https://github.com/clvv/fasd ~/fasd && cd ~/fasd && sudo make install && break
            cd $tmp
        done
    fi

    #Instalando dependencias
    echo -e "$verde Instalando dependencias de$rojo Bashit$gris"
    sudo apt install -y rbenv >> /dev/null 2>> /dev/null

    #Habilitar todos los plugins
    #TOFIX → ENTRA CUANDO NO TIENE QUE ENTRAR E INTENTA INSTALAR LO QUE NO TIENE QUE INSTALAR DANDO ERROR
    #SIEMPRE ESTOY EN BASH.... tratar modo de que solo entre cuando estoy con perfil de bash cargado y bashit instalado
    if [ -z $BASH ]
    then
        echo -e "$verde Para habilitar los$rojo plugins$verde ejecuta este scripts desde$rojo bash$gris"
    elif [ -n $BASH ] && [ "$BASH" = '/bin/bash' ]
    then
        echo -e "$verde Habilitando todos los plugins para$rojo Bashit$gris"
        bash-it enable plugin all
        #Deshabilitar plugins no usados o deprecated
        echo -e "$verde Deshabilitando plugins no usados en$rojo Bashit$gris"
        bash-it disable plugin chruby chruby-auto z z_autoenv
    else
        echo -e "$verde Asegurate de ejecutar con$rojo bash$verde este$rojo script$verde para poder instalar plugins$gris"
    fi
}

#Funcion para configurar VIM con sus temas y complementos
function configurar_vim() {
    echo -e "$verde Configurando VIM"
    #Instalar Gestor de Plugins Vundle
    echo -e "$verde Instalando gestor de plugins$rojo Vundle$verde (Puede tardar un poco)$gris"
    if [ -d ~/.vim/bundle/Vundle.vim ]
    then #Si existe solo actualiza plugins
        echo -e "$verde Vundle ya está instalado, instalando plugins nuevos$gris"
        echo | vim +PluginInstall +qall || rm -R ~/.vim/bundle/Vundle.vim #Si falla borra dir
        if [ ! -d ~/.vim/bundle/Vundle.vim ] #Comprueba si se ha borrado para rehacer
        then
            for (( i=1; i<=3; i++ ))
            do
                git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
                echo | vim +PluginInstall +qall && break;
                if [ $i -eq 3 ]
                then
                    rm -R ~/.vim/bundle/Vundle.vim
                    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
                    echo | vim +PluginInstall +qall && break;
                fi
            done
        fi
    else #Instala plugins dentro de ~/.vimrc #Se intenta 3 veces
        echo -e "$verde Vundle no está instalado, comenzando descarga$gris"
        for (( i=1; i<=3; i++ ))
        do
            rm -R ~/.vim/bundle/Vundle.vim 2>> /dev/null
            git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
            echo | vim +PluginInstall +qall && break;
            if [ $i -eq 3 ]
            then
                rm -R ~/.vim/bundle/Vundle.vim
                git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
                echo | vim +PluginInstall +qall && break;
            fi
        done
    fi
    cd $DIR_ACTUAL

    #Funcion para instalar todos los plugins
    function vim_plugins() {
        plugins_vim=("align" "closetag" "powerline" "youcompleteme" "xmledit" "autopep8" "python-jedi" "python-indent" "utilsinps" "utl" "rails" "snippets" "fugitive" "ctrlp")
        for plugin in ${plugins_vim[*]}
        do
            echo -e "$verde Activando el plugin  → $rojo $plugin$yellow"
            vim-addon-manager install $plugin >> /dev/null 2>> /dev/null
            vim-addon-manager enable $plugin >> /dev/null 2>> /dev/null
        done
        echo -e "$verde Todos los plugins activados$gris"
    }

    function vim_colores() {
        mkdir -p ~/.vim/colors 2>> /dev/null
        #Creando archivos de colores, por defecto usara "monokai"
        echo -e "$verde Descargando colores para sintaxis$amarillo"
        if [ ! -f "~/.vim/colors/wombat.vim" ]
        then
            wget http://www.vim.org/scripts/download_script.php?src_id=6657 -O ~/.vim/colors/wombat.vim
        fi

        echo -e "$verde Descargando Tema$rojo Monokai$amarillo"
        if [ ! -f "~/.vim/colors/monokai.vim" ]
        then
            wget https://raw.githubusercontent.com/lsdr/monokai/master/colors/monokai.vim -O ~/.vim/colors/monokai.vim
        fi
        echo -e "$verde Se ha concluido la instalacion de temas de colores$gris"
    }

    vim_plugins
    vim_colores
}

#Agregar Archivos de configuración al home
function agregar_conf_home() {
      conf=$(ls -A ./home/)
    echo -e "$verde Preparando para añadir archivos de configuración en el home de usuario$gris"
    for c in $conf
    do
        if [ -f ~/$c ] || [ -d ~/$c ] #Si existe hago backup
        then
            if [ -f "~/$c.BACKUP" ] || [ -f "~/$c.BACKUP" ] #Contemplo que exista copia y no la borra
            then
                rm ~/$c 2>> /dev/null
            else
                echo -e "$verde Creando backup de ~/home/$(whoami)/$c $gris"
                mv ~/$c ~/$c.BACKUP 2>> /dev/null
            fi
        fi
        echo -e "$verde Generando configuración$gris"
        cp -r ./home/$c ~/$c 2>> /dev/null
    done
}

#Permisos
function permisos() {
    #sudo rm /bin/atom #Parece que no se crea en las últimas versiones
    echo -e "$verde Estableciendo permisos en el sistema$gris"
}

#Establecer programas por defecto
function programas_default() {
    echo -e "$verde Estableciendo programas por defecto$gris"

    #TERMINAl
    if [ -f /usr/bin/tilix ]
    then
        echo -e "$verde Estableciendo terminal por defecto a$rojo Tilix$gris"
        #TOFIX → Mal formado → Enlace - nombre - ruta -prioridad
        #sudo update-alternatives --install /usr/bin/tilix x-terminal-emulator /usr/bin/tilix 1
        sudo touch /etc/profile.d/vte.sh 2>> /dev/null
        #TOFIX → No existe Tilix como alternativa, reparar primer paso
        sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix 2>> /dev/null
    elif [ -f /usr/bin/terminator ]
    then
        echo -e "$verde Estableciendo terminal por defecto a$rojo Terminator$gris"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/terminator
    elif [ -f /usr/bin/sakura ]
    then
        echo -e "$verde Estableciendo terminal por defecto a$rojo Sakura$gris"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/sakura
    else
        echo -e "$verde Estableciendo terminal por defecto a$rojo XTerm$gris"
        sudo update-alternatives --set x-terminal-emulator /usr/bin/xterm
    fi

    #Navegador
    if [ -f /usr/bin/firefox-esr ]
    then
        echo -e "$verde Estableciendo Navegador WEB por defecto a$rojo Firefox-ESR$gris"
        sudo update-alternatives --set x-www-browser /usr/bin/firefox-esr
        sudo update-alternatives --set gnome-www-browser /user/bin/firefox-esr 2>> /dev/null
    elif [ -f /usr/bin/firefox ]
    then
        echo -e "$verde Estableciendo Navegador WEB por defecto a$rojo Firefox$gris"
        sudo update-alternatives --set x-www-browser /usr/bin/firefox
        sudo update-alternatives --set gnome-www-browser /user/bin/firefox 2>> /dev/null
    elif [ -f /usr/bin/chromium ]
    then
        echo -e "$verde Estableciendo Navegador WEB por defecto a$rojo Chromium$gris"
        sudo update-alternatives --set x-www-browser /usr/bin/chromium
        sudo update-alternatives --set gnome-www-browser /user/bin/chromium 2>> /dev/null
    elif [ -f /usr/bin/chrome ]
    then
        echo -e "$verde Estableciendo Navegador WEB por defecto a$rojo chrome$gris"
        sudo update-alternatives --set x-www-browser /usr/bin/chrome
        sudo update-alternatives --set gnome-www-browser /user/bin/chrome 2>> /dev/null
    fi

    #Editor de texto terminal
    if [ -f /usr/bin/vim.gtk3 ]
    then
        echo -e "$verde Estableciendo Editor por defecto a$rojo Vim GTK3$gris"
        sudo update-alternatives --set editor /usr/bin/vim.gtk3
    elif [ -f /usr/bin/vim ]
    then
        echo -e "$verde Estableciendo Editor WEB por defecto a$rojo Vim$gris"
        sudo update-alternatives --set editor /usr/bin/vim
    elif [ -f /bin/nano ]
    then
        echo -e "$verde Estableciendo Editor WEB por defecto a$rojo Nano$gris"
        sudo update-alternatives --set editor /bin/nano
    fi

    #Editor de texto con GUI
    if [ -f /usr/bin/gedit ]
    then
        echo -e "$verde Estableciendo Editor GUI por defecto a$rojo Gedit$gris"
        sudo update-alternatives --set gnome-text-editor /usr/bin/gedit
    elif [ -f /usr/bin/kate ]
    then
        echo -e "$verde Estableciendo Editor GUI por defecto a$rojo Kate$gris"
        sudo update-alternatives --set gnome-text-editor /usr/bin/kate
    elif [ -f /usr/bin/leafpad ]
    then
        echo -e "$verde Estableciendo Editor GUI por defecto a$rojo Leafpad$gris"
        sudo update-alternatives --set gnome-text-editor /usr/bin/leafpad
    fi
}

#Elegir intérprete de comandos
function terminal() {
    while true
    do
        echo -e "$verde Selecciona a continuación el$rojo terminal$verde a usar$gris"
        echo -e "$verde Tenga en cuenta que este script está optimizado para$rojo bash$gris"
        echo -e "$verde 1) bash$gris"
        echo -e "$verde 2) zsh$gris"
        read -p "Introduce el terminal → bash/zsh: " term
        case $term in
            bash | 1)#Establecer bash como terminal
                chsh -s /bin/bash
                break;;
            zsh | 2)#Establecer zsh como terminal
                chsh -s /bin/zsh
                break;;
            *)#Opción errónea
                echo -e "$rojo Opción no válida$gris"
        esac
    done
}

function configurar_gedit() {
    mkdir -p ~/.local/share/ 2>> /dev/null
    cp -r ./gedit/.local/share/* ~/.local/share/

    mkdir -p ~/.config/gedit/ 2>> /dev/null
    cp -r ./gedit/.config/gedit/* ~/.config/gedit/
}

#Instalar Todas las configuraciones
function instalar_configuraciones() {
    bashit
    ohMyZSH
    permisos
    programas_default
    configurar_vim
    configurar_gedit
    agregar_conf_home
    terminal #Pregunta el terminal a usar

    sudo update-command-not-found
}
