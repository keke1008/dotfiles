# ~/.bashrc: executed by bash(1) for non-login shells.

if [ -n "${DOTFILES_DOT_BASHRC_LOADING:-}" ]; then
	return 0
fi

if [ -r "${DOTFILES_ORIGINAL_HOME}/bash/.bashrc" ]; then
	DOTFILES_ORIGINAL_LOADING=1 DOTFILES_DOT_BASHRC_LOADING=1 \
		. "${DOTFILES_ORIGINAL_HOME}/bash/.bashrc"
fi

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

if [ -r "${HOME}/.shrc" ]; then
	. "${HOME}/.shrc"
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

# direnv
if command -v "direnv" >/dev/null; then
	eval "$(direnv hook bash)"
fi

if command -v "fzf" >/dev/null; then
	eval "$(fzf --bash)"
fi

if command -v "starship" >/dev/null; then
	eval "$(starship init bash)"
else
	PS1='\[\e[32m\]\u\[\e[32m\]@\[\e[32m\]\h \[\e[34m\]\w \[\e[35m\]exit: $?, jobs: \j \[\e[36m\]$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2 | xargs -I {} echo "({})")\n\[\e[38;5;242m\]\$ \[\e[0m\]'
fi

local_rc="${DOTFILES_LOCAL_HOME}/bash/local_rc.sh"
if [ -r "${local_rc}" ]; then
	. "${local_rc}"
fi
