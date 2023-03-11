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

###################################
###          CONSTANTES         ###
###################################
USER="$(whoami)" ## Nombre del usuario

## En caso de no ser ejecutado de forma interactiva se sale sin hacer nada
case $- in
    *i*) ;;
      *) return;;
esac

## Longitud del Historial
HISTSIZE=2000
HISTFILESIZE=8000

## Variable que identifica el chroot (se usa en el prompt)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot="${USER}-->"
fi

## Establece aviso elegante (sin color, o si "queremos" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

## Si estamos con Xterm establece el título (original → user@host:dir)
case "$TERM" in
xterm*|rxvt*)
    PS1='${USER} -→ '
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

## Ruta para npm en $HOME de usuario
if [[ -d "$HOME/.npm/lib" ]] &&
   [[ -d "$HOME/.npm/bin" ]] &&
   [[ -x '/usr/bin/node' ]]
then
    export NODE_PATH=~/.npm/lib/node_modules:$NODE_PATH
    export PATH=~/.npm/bin:$PATH
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
alias gr='git remote'

## Historial
alias c="clear"
alias h="history 20"
alias hh="history 200 | grep "
alias hc="history -c"

## Atajos Generales
alias pip3="pip3 --disable-pip-version-check"

## Otros
#alias rm="rm -i"
#alias rm="mv ??????/tmp/deleted_$USER"
#alias cp="cp -i"
#alias mv="mv -i"

###################################
###  Opciones para bash propias ###
###################################
if [[ ! -d "/tmp/deleted_$USER" ]]; then
    mkdir "/tmp/deleted_$USER" && chmod 700 -R "/tmp/deleted_$USER"
fi

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

## Permisos por defecto para nuevos archivos
umask 007
