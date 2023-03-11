#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      raul@fryntiz.dev
## @web        https://fryntiz.es
## @github     https://github.com/fryntiz
## @gitlab     https://gitlab.com/fryntiz
## @twitter    https://twitter.com/fryntiz
##
##             Applied Style Guide:
## @style      https://gitlab.com/fryntiz/bash-guide-style

###################################
###          CONSTANTES         ###
###################################
RO="\033[1;31m"  ## Color Rojo
VE="\033[1;32m"  ## Color Verde
CL="\e[0m"       ## Limpiar colores

USER="$(whoami)" ## Nombre del usuario

## En caso de no ser ejecutado de forma interactiva se sale sin hacer nada
case $- in
    *i*) ;;
      *) return;;
esac

###################################
###           ohmyzsh           ###
###################################

if [[ -d $HOME/.oh-my-zsh ]]; then

    # Path to your oh-my-zsh installation.
    export ZSH=$HOME/.oh-my-zsh

    ## Tema de zsh que será cargado desde $HOME/.oh-my-zsh/themes/
    ZSH_THEME="agnoster"
    #ZSH_THEME="refined"

    # Uncomment the following line to use case-sensitive completion.
    # CASE_SENSITIVE="true"

    # Uncomment the following line to disable bi-weekly auto-update checks.
    # DISABLE_AUTO_UPDATE="true"

    # Uncomment the following line to change how often to auto-update (in days).
    # export UPDATE_ZSH_DAYS=13

    # Uncomment the following line to disable colors in ls.
    # DISABLE_LS_COLORS="true"

    # Uncomment the following line to disable auto-setting terminal title.
    # DISABLE_AUTO_TITLE="true"

    # Uncomment the following line to enable command auto-correction.
    # ENABLE_CORRECTION="true"

    # Uncomment the following line to display red dots whilst waiting for completion.
    # COMPLETION_WAITING_DOTS="true"

    # Uncomment the following line if you want to disable marking untracked files
    # under VCS as dirty. This makes repository status check for large repositories
    # much, much faster.
    # DISABLE_UNTRACKED_FILES_DIRTY="true"

    # Uncomment the following line if you want to change the command execution time
    # stamp shown in the history command output.
    # The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    HIST_STAMPS="dd/mm/yyyy"

    # Would you like to use another custom folder than $ZSH/custom?
    # ZSH_CUSTOM=/path/to/new-custom-folder

    # Estas líneas deben ir antes de llamar a oh-my-zsh.sh si se quiere usar el
    # plugin de arranque automático de tmux:
    ZSH_TMUX_AUTOSTART="true"
    ZSH_TMUX_AUTOCONNECT="false"
    # ZSH_TMUX_AUTOQUIT="false"
    export TERM=screen-256color

    # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    #plugins=(git tmux command-not-found composer history-substring-search vi-mode zsh-syntax-highlighting z)
    plugins=(git command-not-found composer history-substring-search vi-mode z)

    source $ZSH/oh-my-zsh.sh


    # Desactivar si se usa el plugin tmux de oh-my-zsh:
    # alias tmux="tmux -2"
fi

## Deshabilita el prompt (Nombre de usuario y máquina)
prompt_context(){}

## No comprobar el correo del sistema al abrir terminal.
unset MAILCHECK

## No añadir líneas duplicadas o que comienzan con espacios al historial.
HISTCONTROL=ignoreboth

## Agregar al archivo de historial (En vez de sobreescribirlo)
shopt &> /dev/null && shopt -s histappend

## Longitud del Historial
HISTSIZE=3000
HISTFILESIZE=12000

## Comprobar tamaño de ventana tras cada comando (Actualiza "LINES" y "COLUMNS")
shopt &> /dev/null && shopt -s checkwinsize

## Variable que identifica el chroot (se usa en el prompt)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    #debian_chroot=$(cat /etc/debian_chroot)
    debian_chroot="$(whoami) %~ $"
fi

## Establece aviso elegante (sin color, o si "queremos" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

## Avisos de color si el terminal puede convertirlos.
force_color_prompt=yes

if [[ -n "$force_color_prompt" ]]; then
    if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
        ## We have color support; assume it's compliant with Ecma-48
        ## (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        ## a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi


unset color_prompt force_color_prompt


## Si estamos con Xterm establece el título (original → user@host:dir)
case "$TERM" in
xterm*|rxvt*)
    PS1="%~ $"
    ;;
*)
    ;;
esac



###################################
###       Rutas a binarios      ###
###################################
if [[ -d $HOME/bin ]]; then
    PATH=$PATH:$HOME/bin
fi

if [[ -d $HOME/.local/bin ]]; then
    PATH=$PATH:$HOME/.local/bin
fi

if [[ -d $HOME/.config/composer/vendor/bin ]]; then
    PATH=$PATH:$HOME/.config/composer/vendor/bin
fi

###################################
###            COLOR            ###
###################################
## Habilita el soporte de color para "ls" y algunos alias
if [[ -x '/usr/bin/dircolors' ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## Colorear Errores y Advertencias de GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

## Alias importados desde subdirectorio ~/.bash_aliases
if [[ -f $HOME/.zsh_aliases ]]; then
    . $HOME/.zsh_aliases
fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8


## Compatibilidad con terminal "Tilix"
if [[ "$TILIX_ID" ]] || [[ "$VTE_VERSION" ]]; then
    source /etc/profile.d/vte.sh 2>/dev/null
fi

## Ruta para npm en $HOME de usuario
if [[ -d "$HOME/.npm/lib" ]] &&
   [[ -d "$HOME/.npm/bin" ]]
then
    export NODE_PATH=~/.npm/lib/node_modules:$NODE_PATH
    export PATH=~/.npm/bin:$PATH
fi


## POWERLINE EN BASH (No lo uso, el siguiente código puede no funcionar bien)
#if [[ -f /usr/bin/powerline-daemon ]]; then
#    /usr/share/powerline/bindings/bash/powerline.sh -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#    . /usr/share/powerline/bindings/bash/powerline.sh
#fi


# Editor local y remoto
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR="vim"
else
    export EDITOR="vim"
fi

if [[ -x '/usr/bin/vim' ]]; then
    export EDITOR='vim'
elif [[ -x '/usr/bin/nano' ]]; then
    export EDITOR='nano -c'
fi

###################################
### Mensaje al iniciar terminal ###
###################################

if [[ -n $SSH_CONNECTION ]]; then
    echo ''
elif [[ -f '/usr/bin/neofetch' ]] || [[ -f '/opt/homebrew/bin/neofetch' ]]; then
    neofetch
elif [[ -f '/usr/bin/screenfetch' ]]; then
    screenfetch
fi

if [[ -f '/usr/bin/fryntiz' ]]; then
    echo -e "      \033[1;31m Para utilizar el menú interactivo usa el comando \033[1;32m\"fryntiz\" \033[1;00m"
fi

if [[ -x "$HOME/.local/bin/proyecto" ]]; then
    echo -e "$VE Con el comando$RO proyecto$VE puedes generar un proyecto nuevo$CL"
fi

if [[ -x "$HOME/.local/bin/nuevo" ]]; then
    echo -e "$VE Usando el comando$RO nuevo$VE generas un archivo desde la plantilla$CL"
fi

###################################
###            ALIAS            ###
###################################
## Comando ls
alias ll='ls -hl'
alias la='ls -A'
alias l='ls -CF'

## Comando cd
alias ..="cd .."
alias cd..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

## Git
alias git="LANG=C git"
alias glg="git lg"
alias glf='git lg --show-signature'
alias gl='git lg'
alias gh='git hist'
alias gs='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias go='git checkout'
alias gk='gitk --all&'
alias gx='gitx --all'
alias got='git'
alias get='git'
alias gp='git push'
alias gr='git remote'

## Historial
alias c="clear"
alias h="history 20"
alias hh="history 200 | grep "
alias hc="history -c"

## Navegar hacia directorios
alias tw="cd /var/www"
alias tg="cd $HOME/git"
alias tx="cd $HOME/git/4-Xerintel"
alias tgx="cd $HOME/git/4-Xerintel"
alias tgl="cd $HOME/git/1-Projects/LaGuiaLinux"
alias tgd="cd $HOME/git/1-Projects/DesdeChipiona"

## Otros
#alias rm="rm -i"
#alias rm="mv ??????/tmp/deleted_$USER"
#alias cp="cp -i"
#alias mv="mv -i"

## Cambio lenguaje "go" por que lo uso como git checkout
#alias goo="/path/to/go"

## Python
alias pip3="pip3 --disable-pip-version-check"
alias pip=pip3
alias python=python3.9

## Aplicaciones renombradas
if [[ -x '/usr/bin/trans' ]]; then
    alias t="trans :es"
fi

## Reproducción de voz
if [[ -x '/usr/bin/espeak' ]]; then
    alias espeaker='espeak -ves+f2 -s150 -p80'
fi

## Activo gestos en touchpad, principalmente i3wm
if [[ -x '/usr/bin/synclient' ]]; then
    synclient EmulateMidButtonTime=1 TouchpadOff=0 VertTwoFingerScroll=1 HorizTwoFingerScroll=1 VertEdgeScroll=1 TapButton1=1 TapButton2=3 TapButton3=2 ClickFinger1=1 ClickFinger2=2 ClickFinger3=3
fi





###################################
###   Variables de desarrollo   ###
###################################
## pyenv (python)
if [[ -d $HOME/.pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi
fi

export GIT_PS1_SHOWDIRTYSTATE=1

# Para que las aplicaciones Java se vean mejor:
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

export LESSCHARSET=UTF-8

## Less Colors for Man Pages

export LESS_TERMCAP_mb=$'\E[01;31m'       ## begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  ## begin bold
export LESS_TERMCAP_me=$'\E[0m'           ## end mode
export LESS_TERMCAP_se=$'\E[0m'           ## end standout-mode
export LESS_TERMCAP_so=$(tput bold; tput setaf 16; tput setab 4)
export LESS_TERMCAP_ue=$'\E[0m'           ## end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' ## begin underline

###################################
### Configurando java y android ###
###################################
#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
#export JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
#export ANDROID_HOME=$HOME/Android/Sdk
#export ANDROID_SDK_ROOT=$HOME/Android/Sdk
#export ANDROID_AVD_HOME=$HOME/.android/avd
#export PATH=$PATH:$ANDROID_HOME/tools
#export PATH=$PATH:$ANDROID_HOME/platform-tools

#sudo update-alternatives --config java
#sudo update-alternatives --config javac


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

## Permisos por defecto para nuevos archivos
umask 007

export KEYTIMEOUT=1

# Rutas a ejecutables
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games:/usr/local/games:$HOME/.local/bin"

###################################
### Incluyo configuración extra ###
###################################
if [[ ! -d "/tmp/deleted_$USER" ]]; then
    mkdir "/tmp/deleted_$USER" && chmod 700 -R "/tmp/deleted_$USER"
fi

if [[ -f $HOME/.zshrc_custom ]]; then ## Comprobar si existe para el usuario
    source $HOME/.zshrc_custom
else
    touch "$HOME/.zshrc_custom"
    echo '## Añade en este archivo tus personalizaciones' >> "$HOME/.zshrc_custom"
fi

## Comparto tty1 mediante screen al hacer login en ella
## screen -r #Listar pantallas compartidas
## screen -S pantalla
if [[ "$(/usr/bin/tty)" == "/dev/tty1" ]] && [[ -x '/usr/bin/screen' ]]; then
    exec /usr/bin/screen
fi
