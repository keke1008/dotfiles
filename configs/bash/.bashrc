# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# load $DOTPATH
export DOTPATH=$(cat "$HOME/.dotpath")

# mapping
stty werase undef
bind '\C-w:unix-filename-rubout'

if ! type vim > /dev/null 2>&1; then
  alias vim='vi'
fi

if type nvim > /dev/null 2>&1; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# alises
alias v="${EDITOR}"
alias g='git'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# if running in WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  export PATH=$DOTPATH/bin/wsl:$PATH
  export BROWSER=firefox
  export DISPLAY=`hostname`.mshome.net:0.0
fi

PS1='\[\e[32m\]\u\[\e[32m\]@\[\e[32m\]\h \[\e[34m\]\w \[\e[35m\]exit: $?, jobs: \j \[\e[36m\]$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2 | xargs -I {} echo "({})")\n\[\e[38;5;242m\]\$ \[\e[0m\]'
