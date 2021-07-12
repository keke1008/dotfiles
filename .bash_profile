# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# trash-cli
type trash-put > /dev/null 2>&1 && alias rm=trash-put
type trash-list > /dev/null 2>&1 && alias rmls=trash-list
type trash-empty > /dev/null 2>&1 && alias rmempty=trash-empty
type trash-restore > /dev/null 2>&1 && alias rmres=trash-restore

# add cargo path
test -e "$HOME/.cargo/env" && . "$HOME/.cargo/env"

export PS1='\n\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;36m\]$(__git_ps1 " (%s) ")\[\033[01;32m\]\$\[\033[00m\]'

# run tmux if not inside a tmux session and tmux has been installed
type tmux > /dev/null 2>&1 && test -z "$TMUX" && tmux

# Enable when using WSL.
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
  alias      exp=~/dotfiles/bin/open_explorer.sh
  alias  firefox=~/dotfiles/bin/open_firefox.sh
  export BROWSER=~/dotfiles/bin/open_firefox.sh
  export DISPLAY=`hostname`.mshome.net:0.0
fi
