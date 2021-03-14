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

alias exp=explorer.exe

if type trash-put &> /dev/null ; then
  alias rm=trash-put
fi

if type trash-list &> /dev/null ; then
  alias rmls=trash-list
fi

if type trash-empty &> /dev/null ; then
  alias rmempty=trash-empty
fi

export PS1='\n\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;36m\]$(__git_ps1 " (%s) ")\[\033[01;32m\]\$\[\033[00m\]'
export VIMRUNTIME="/usr/share/nvim/runtime"
