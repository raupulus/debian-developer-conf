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

RO="\033[1;31m"  ## Color Rojo
VE="\033[1;32m"  ## Color Verde
CL="\e[0m"       ## Limpiar colores

## En caso de no ser ejecutado de forma interactiva se sale sin hacer nada
case $- in
    *i*) ;;
      *) return;;
esac

## No añadir líneas duplicadas o que comienzan con espacios al historial.
HISTCONTROL=ignoreboth

## Agregar al archivo de histoarial (En vez de sobreescribirlo)
shopt -s histappend

## Longitud del Historial
HISTSIZE=2000
HISTFILESIZE=8000

## Comprobar tamaño de ventana tras cada comando (Actualiza "LINES" y "COLUMNS")
shopt -s checkwinsize

## If set, the pattern "**" used in a pathname expansion context will
## match all files and zero or more directories and subdirectories.
#shopt -s globstar

## make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

## Variable que identifica el chroot (se usa en el prompt)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    #debian_chroot=$(cat /etc/debian_chroot)
    debian_chroot="$(whoami)-->"
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

if [[ "$color_prompt" = 'yes' ]]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

    ## La siguiente línea está modificada para que muestre la ruta en otra línea y solo el usuario actual
    PS1='\n\[\033[01;37m\]Estás en:\[\033[00m\] \[\033[01;33m\]\w\[\033[00m\]$(__git_ps1 " (%s)")\n\[\033[01;32m\]\u\[\033[00m\] \[\033[01;31m\]>>\[\033[00m\] '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='bash;$(__git_ps1 " (%s))"'
fi
unset color_prompt force_color_prompt

## Si estamos con Xterm establece el título (original → user@host:dir)
case "$TERM" in
xterm*|rxvt*)
    PS1='$(__git_ps1 " (%s))"'
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
###   Variables de desarrollo   ###
###################################
## Pyenv, permite establecer versiones de python distintas para cada proyecto
if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"

    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi
fi

###################################
###            COLOR            ###
###################################
## Habilita el soporte de color para "ls" y algunos alias
if [[ -x /usr/bin/dircolors ]]; then
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

## Otros
#alias rm="rm -i"
#alias cp="cp -i"
#alias mv="mv -i"

## Alias importados desde subdirectorio ~/.bash_aliases
if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

## Habilitar Autocompletado, se obtiene de "sources /etc/bash.bashrc)"
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

## Compatibilidad con terminal "Tilix"
if [[ "$TILIX_ID" ]] || [[ "$VTE_VERSION" ]]; then
    source /etc/profile.d/vte.sh
fi

## POWERLINE EN BASH (No lo uso, el siguiente código puede no funcionar bien)
#if [[ -f /usr/bin/powerline-daemon ]]; then
#    /usr/share/powerline/bindings/bash/powerline.sh -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#    . /usr/share/powerline/bindings/bash/powerline.sh
#fi

###################################
### Mensaje al iniciar terminal ###
###################################
if [[ -f '/usr/bin/neofetch' ]]; then
    neofetch
elif [[ -f '/usr/bin/screenfetch' ]]; then
    screenfetch
fi

if [[ -f '/usr/bin/fryntiz' ]]; then
    echo -e "      \033[1;31m Para utilizar el menú interactivo usa el comando \033[1;32m\"fryntiz\" \033[1;00m"
fi

###################################
###     Exportando variables    ###
###################################
## Exportar editor de terminal
#export EDITOR="nano -c"
export EDITOR="vim"
export GIT_PS1_SHOWDIRTYSTATE=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

## Less Colors for Man Pages
export LESSCHARSET=UTF-8
export LESS_TERMCAP_mb=$'\E[01;31m'       ## begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  ## begin bold
export LESS_TERMCAP_me=$'\E[0m'           ## end mode
export LESS_TERMCAP_se=$'\E[0m'           ## end standout-mode
export LESS_TERMCAP_so=$(tput bold; tput setaf 16; tput setab 4)
export LESS_TERMCAP_ue=$'\E[0m'           ## end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' ## begin underline

###################################
###     Configurando Bash-it    ###
###################################
## Comprobar si está instalado para el usuario
if [[ -f ~/.bash_it/bash_it.sh ]]; then
    ## Directorio con la configuración para bash_it
    export BASH_IT="/$HOME/.bash_it"

    ## Tema de bash que será cargado desde $HOME/.bash_it/themes/
    export BASH_IT_THEME='powerline-multiline'
    #export BASH_IT_THEME='iterate'

    ## (Advanced): Change this to the name of your remote repo if you
    ## cloned bash-it with a remote other than origin such as `bash-it`.
    ## export BASH_IT_REMOTE='bash-it'

    ## Your place for hosting Git repos. I use this for private repos.
    #export GIT_HOSTING='usuario@servidor'

    ## No comprobar el correo del sistema al abrir terminal.
    unset MAILCHECK

    ## Change this to your console based IRC client of choice.
    #export IRC_CLIENT='irssi'

    ## Set this to the command you use for todo.txt-cli
    export TODO="t"

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
    ## export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

    ## Cargar Bash-it
    source "$BASH_IT"/bash_it.sh
fi

###################################
###  Opciones para bash propias ###
###################################
if [[ -f ~/.bashrc_custom ]]; then ## Comprobar si existe para el usuario
    source $HOME/.bashrc_custom
else
    touch "$HOME/.bashrc_custom"
    echo '## Añade en este archivo tus personalizaciones' >> "$HOME/.bashrc_custom"
fi

if [[ -x "$HOME/.local/bin/proyecto" ]]; then
    echo -e "$VE Con el comando$RO proyecto$VE puedes generar un proyecto nuevo$CL"
fi

if [[ -x "$HOME/.local/bin/nuevo" ]]; then
    echo -e "$VE Usando el comando$RO nuevo$VE generas un archivo desde la plantilla$CL"
fi

## Comparto tty1 mediante screen al hacer login en ella
if [[ "$(/usr/bin/tty)" == "/dev/tty1" ]] && [[ -x '/usr/bin/screen' ]]; then
    exec /usr/bin/screen
fi

###################################
###  Sobrescribiendo Comandos   ###
###################################
## devicons-ls (Iconos para terminal al hacer ls)
#if [[ -x "$HOME/.local/bin/devicons-ls" ]]; then
#    alias ls='devicons-ls'
#fi
