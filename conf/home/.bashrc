#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-
##
## @author     Raúl Caro Pastorino
## @copyright  Copyright © 2017 Raúl Caro Pastorino
## @license    https://wwww.gnu.org/licenses/gpl.txt
## @email      public@raupulus.dev
## @web        https://raupulus.dev
## @github     https://github.com/raupulus
## @gitlab     https://gitlab.com/raupulus
## @twitter    https://twitter.com/raupulus
##
##             Applied Style Guide:
## @style      https://gitlab.com/raupulus/bash-guide-style

###################################
###          CONSTANTES         ###
###################################
RO="\033[1;31m"  ## Color Rojo
VE="\033[1;32m"  ## Color Verde
CL="\e[0m"       ## Limpiar colores

USER="$(whoami)" ## Nombre del usuario

# Entorno
export LANG=es_ES.UTF-8
export LANGUAGE=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8
export LC_CTYPE=es_ES.UTF-8
export LC_MESSAGES=es_ES.UTF-8

## No comprobar el correo del sistema al abrir terminal.
unset MAILCHECK

## No añadir líneas duplicadas o que comienzan con espacios al historial.
HISTCONTROL=ignoreboth

## Agregar al archivo de historial (En vez de sobreescribirlo)
shopt -s histappend

## Longitud del Historial
HISTSIZE=3000
HISTFILESIZE=12000

## Comprobar tamaño de ventana tras cada comando (Actualiza "LINES" y "COLUMNS")
shopt -s checkwinsize

IS_CHROOT=0

## Variable que identifica el chroot (se usa en el prompt)
## TODO: Buscar forma más genérica entre sistemas, solo funciona en debian
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    #debian_chroot=$(cat /etc/debian_chroot)
    $IS_CHROOT=1
    #debian_chroot="$(whoami) >>"
fi


## PROMPT base, se modificará posteriormente según el entorno
if [[ -n $SSH_CONNECTION ]]; then
    PS1='~$ '
fi


###################################
###       Rutas a binarios      ###
###################################
if [[ -d $HOME/bin ]]; then
    PATH=$PATH:$HOME/bin
fi

if [[ -d $HOME/.bin ]]; then
    PATH=$PATH:$HOME/.bin
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
if [[ -f $HOME/.bash_aliases ]]; then
    . $HOME/.bash_aliases
fi

## Habilitar Autocompletado, se obtiene de "sources /etc/bash.bashrc)"
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]] && [[ -x /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]] && [[ -x /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

## Compatibilidad con terminal "Tilix"
if [[ "$TILIX_ID" ]] || [[ "$VTE_VERSION" ]] && [[ -f "/etc/profile.d/vte.sh" ]]; then
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
#alias python=python3.9

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
export LESS_TERMCAP_ue=$'\E[0m'           ## end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' ## begin underline


if [[ $IS_CHROOT -eq 1 ]] || [[ -n $SSH_CONNECTION ]]; then
    echo ''
else
    export LESS_TERMCAP_so=$(tput bold; tput setaf 16; tput setab 4)
fi


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

# Rutas a ejecutables: CUIDADO!!
#export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games:/usr/local/games:$HOME/.local/bin"

###################################
### Incluyo configuración extra ###
###################################
if [[ ! -d "/tmp/deleted_$USER" ]]; then
    mkdir "/tmp/deleted_$USER" && chmod 700 -R "/tmp/deleted_$USER"
fi

if [[ -f $HOME/.bashrc_custom ]]; then ## Comprobar si existe para el usuario
    source $HOME/.bashrc_custom
else
    touch "$HOME/.bashrc_custom"
    echo '## Añade en este archivo tus personalizaciones' >> "$HOME/.bashrc_custom"
fi

## Comparto tty1 mediante screen al hacer login en ella
## screen -r #Listar pantallas compartidas
## screen -S pantalla
if [[ "$(/usr/bin/tty)" == "/dev/tty1" ]] && [[ -x '/usr/bin/screen' ]]; then
    exec /usr/bin/screen
fi


###################################
###           bash-it           ###
###################################

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

## Mensajes adicionales según el modo de conexión
if [[ -n $SSH_CONNECTION ]]; then
    echo ''
else
    if [[ -f '/usr/bin/fryntiz' ]]; then
        echo -e "      \033[1;31m Para utilizar el menú interactivo usa el comando \033[1;32m\"fryntiz\" \033[1;00m"
    fi

    if [[ -x "$HOME/.local/bin/proyecto" ]]; then
        echo -e "$VE Con el comando$RO proyecto$VE puedes generar un proyecto nuevo$CL"
    fi

    if [[ -x "$HOME/.local/bin/nuevo" ]]; then
        echo -e "$VE Usando el comando$RO nuevo$VE generas un archivo desde la plantilla$CL"
    fi
fi


###################################
###           PROMPT            ###
###################################

if [[ $IS_CHROOT -eq 1 ]]; then ## En caso de estar por chroot
    #echo 'CHROOT CONNECTION'
    debian_chroot="$(whoami) >>"
elif [[ -n $SSH_CONNECTION ]]; then ## En caso de ser conexión remota ssh (NO COMPROBADO BIEN, REVISAR!!!!)
    #echo 'SSH CONNECTION'

    if [ "$color_prompt" = yes ]; then
        PS1='\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]> '
    else
        PS1='\u@\h:\w> '
    fi
elif [[ -f $HOME/.bash_it/bash_it.sh ]]; then ## En caso de tener bashit
    ## En caso de no ser ejecutado de forma interactiva se sale sin hacer nada
    case $- in
    *i*) ;;
        *) return;;
    esac

    ## Directorio con la configuración para bash_it
    export BASH_IT="$HOME/.bash_it"

    ## Tema de bash que será cargado desde $HOME/.bash_it/themes/
    export BASH_IT_THEME='powerline-multiline'
    #export BASH_IT_THEME='iterate'

    ## (Advanced): Change this to the name of your remote repo if you
    ## cloned bash-it with a remote other than origin such as `bash-it`.
    ## export BASH_IT_REMOTE='bash-it'

    ## Your place for hosting Git repos. I use this for private repos.
    #export GIT_HOSTING='usuario@servidor'

    ## Change this to your console based IRC client of choice.
    #export IRC_CLIENT='irssi'

    ## Set this to the command you use for todo.txt-cli
    #export TODO="t"

    ## Set this to false to turn off version control status checking within the prompt for all themes
    export SCM_CHECK=true

    ## Set Xterm/screen/Tmux title with only a short hostname.
    ## Uncomment this (or set SHORT_HOSTNAME to something else),
    ## Will otherwise fall back on $HOSTNAME.
    #export SHORT_HOSTNAME=$(hostname -s)

    ## Set Xterm/screen/Tmux title with only a short username.
    ## Uncomment this (or set SHORT_USER to something else),
    ## Will otherwise fall back on $USER.
    #export SHORT_USER=${USER:0:8}

    ## Set Xterm/screen/Tmux title with shortened command and directory.
    ## Uncomment this to set.
    export SHORT_TERM_LINE=true

    ## Set vcprompt executable path for scm advance info in prompt (demula theme)
    ## https://github.com/djl/vcprompt
    #export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

    ## (Advanced): Uncomment this to make Bash-it reload itself automatically
    ## after enabling or disabling aliases, plugins, and completions.
    #export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

    #plugins=(git command-not-found composer history-substring-search vi-mode z ssh man javascript python docker node sudo )

    ## Cargar Bash-it
    if [[ -d "${BASH_IT}" && -f "${BASH_IT}/bash_it.sh" ]]; then
        source $BASH_IT/bash_it.sh
    fi
else ## En cualquier otro caso
    ## Si estamos con Xterm establece el título (original → user@host:dir)
    if [ $TERM ]; then
        case "$TERM" in
        xterm*|rxvt*)
            PS1="%~ $"
            ;;
        *)
            ;;
        esac

        ## Establece aviso elegante (sin color, o si "queremos" color)
        case "$TERM" in
            xterm-color) color_prompt=yes;;
        esac
    fi

    ## Avisos de color si el terminal puede convertirlos.
    force_color_prompt=yes

    if [[ -n "$force_color_prompt" ]]; then
        if [[ -x /usr/bin/tput ]] && tput setaf 1 >& /dev/null; then
            ## We have color support; assume it's compliant with Ecma-48
            ## (ISO/IEC-6429). (Lack of such support is extremely rare, and such
            ## a case would tend to support setf rather than setaf.)
            color_prompt=yes
        else
            color_prompt=
        fi
    fi

    if [[ "$color_prompt" = 'yes' ]]; then
        #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

        ## La siguiente línea está modificada para que muestre la ruta en otra línea y solo el usuario actual
        PS1='\n\[\033[01;37m\]Estás en:\[\033[00m\] \[\033[01;33m\]\w\[\033[00m\]$(__git_ps1 " (%s)")\n\[\033[01;32m\]\u\[\033[00m\] \[\033[01;31m\]>>\[\033[00m\] '
    else
        #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
        PS1="%~ $"
    fi

    PS1=">"

    unset color_prompt force_color_prompt
fi
