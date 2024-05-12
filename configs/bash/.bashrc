# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Source common rc file
if [ -r "$DOTPATH/configs/sh/common_rc.sh" ]; then
	. "$DOTPATH/configs/sh/common_rc.sh"
fi

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

# mapping
stty werase undef
bind '\C-w:unix-filename-rubout'

PS1='\[\e[32m\]\u\[\e[32m\]@\[\e[32m\]\h \[\e[34m\]\w \[\e[35m\]exit: $?, jobs: \j \[\e[36m\]$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2 | xargs -I {} echo "({})")\n\[\e[38;5;242m\]\$ \[\e[0m\]'
