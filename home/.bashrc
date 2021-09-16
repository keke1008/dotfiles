# ~/.bashrc: executed by bash(1) for non-login shells.

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
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# environment variables
export VIMRUNTIME="/usr/share/nvim/runtime"
export PS1='\n\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;36m\]$(__git_ps1 " (%s) ")\[\033[01;32m\]\$\[\033[00m\]'
. $HOME/.dotpath

# alises
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
type trash-put > /dev/null 2>&1 && alias rm=trash-put

# run $DOTPATH/lib/autoload/*
for file in $(find $DOTPATH/lib/autoload -type f); do
  . $file
done


# if running in WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  export PATH=$DOTPATH/bin/wsl:$PATH
  export BROWSER=firefox
  export DISPLAY=`hostname`.mshome.net:0.0
fi

# start tmux if tmux is not running.
type tmux > /dev/null 2>&1 && test -z $TMUX && tmux
