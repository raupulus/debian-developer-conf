# Versión Modificada by |>Fryntiz<| → http://www.fryntiz.es && https://github.com/fryntiz
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=8000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    #debian_chroot=$(cat /etc/debian_chroot)
    debian_chroot="$(whoami)-->"
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #La siguiente línea está modificada para que muestre la ruta en otra línea y solo el usuario actual
    PS1='\n\[\033[01;37m\]Estás en:\[\033[00m\] \[\033[01;33m\]\w\[\033[00m\]$(__git_ps1 " (%s)")\n\[\033[01;32m\]\u\[\033[00m\] \[\033[01;31m\]>>\[\033[00m\] '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='bash;$(__git_ps1 " (%s))"'
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
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
if [ -d $HOME/bin ]; then
    PATH=$PATH:$HOME/bin
fi

if [ -d $HOME/.local/bin ]; then
    PATH=$PATH:$HOME/.local/bin
fi

if [ -d $HOME/.config/composer/vendor/bin ]; then
    PATH=$PATH:$HOME/.config/composer/vendor/bin
fi


############################
##         COLOR          ##
############################
# Habilita el soporte de color para "ls" y algunos alias
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Colorear Errores y Advertencias de GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


############################
##         ALIAS          ##
############################
# Comando ls
alias ll='ls -hl'
alias la='ls -A'
alias l='ls -CF'

# Comando cd
alias ..="cd .."
alias cd..="cd .."
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Git
alias git="LANG=C git"
alias glg="git lg"
alias gl='git lg'
alias gh='git hist'
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit '
alias gd='git diff '
alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias got='git '
alias get='git '
alias gp='git push '

# Otros
#alias rm="rm -i"
#alias cp="cp -i"
#alias mv="mv -i"

# Alias importados desde subdirectorio ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Habilitar Autocompletado, se obtiene de "sources /etc/bash.bashrc)"
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Compatibilidad con terminal "Tilix"
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

#POWERLINE EN BASH
#if [ -f /usr/bin/powerline-daemon ]; then
#  /usr/share/powerline/bindings/bash/powerline.sh -q
#  POWERLINE_BASH_CONTINUATION=1
#  POWERLINE_BASH_SELECT=1
#  . /usr/share/powerline/bindings/bash/powerline.sh
#fi

###################################
### Mensaje al iniciar terminal ###
###################################
if [ -f /usr/bin/neofetch ]; then
    neofetch
elif [ -f /usr/bin/screenfetch ]; then
    screenfetch
fi

if [ -f /usr/bin/fryntiz ]; then
    echo -e "      \033[1;31m Para utilizar el menú interactivo usa el comando \033[1;32m\"fryntiz\" \033[1;00m"
fi

###################################
###     Exportando variables    ###
###################################
#Exportar editor de terminal
#export EDITOR="nano -c"
export EDITOR="vim"
export GIT_PS1_SHOWDIRTYSTATE=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

# Less Colors for Man Pages
export LESSCHARSET=UTF-8
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$(tput bold; tput setaf 16; tput setab 4)
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

###################################
###     Configurando Bash-it    ###
###################################
if [ -f ~/.bash_it/bash_it.sh ] #Comprobar si está instalado para el usuario
then
    # Path to the bash it configuration
    export BASH_IT="/$HOME/.bash_it"

    # Lock and Load a custom theme file
    # location /.bash_it/themes/
    #export BASH_IT_THEME='iterate'
    export BASH_IT_THEME='powerline-multiline'

    # (Advanced): Change this to the name of your remote repo if you
    # cloned bash-it with a remote other than origin such as `bash-it`.
    # export BASH_IT_REMOTE='bash-it'

    # Your place for hosting Git repos. I use this for private repos.
    export GIT_HOSTING='usuario@servidor'

    # Don't check mail when opening terminal.
    unset MAILCHECK

    # Change this to your console based IRC client of choice.
    export IRC_CLIENT='irssi'

    # Set this to the command you use for todo.txt-cli
    export TODO="t"

    # Set this to false to turn off version control status checking within the prompt for all themes
    export SCM_CHECK=true

    # Set Xterm/screen/Tmux title with only a short hostname.
    # Uncomment this (or set SHORT_HOSTNAME to something else),
    # Will otherwise fall back on $HOSTNAME.
    #export SHORT_HOSTNAME=$(hostname -s)

    # Set Xterm/screen/Tmux title with only a short username.
    # Uncomment this (or set SHORT_USER to something else),
    # Will otherwise fall back on $USER.
    #export SHORT_USER=${USER:0:8}

    # Set Xterm/screen/Tmux title with shortened command and directory.
    # Uncomment this to set.
    export SHORT_TERM_LINE=true

    # Set vcprompt executable path for scm advance info in prompt (demula theme)
    # https://github.com/djl/vcprompt
    #export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

    # (Advanced): Uncomment this to make Bash-it reload itself automatically
    # after enabling or disabling aliases, plugins, and completions.
    # export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

    # Load Bash It
    source "$BASH_IT"/bash_it.sh
fi
