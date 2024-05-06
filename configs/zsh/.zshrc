if [ -r "$DOTPATH/configs/sh/common_rc.sh" ]; then
    . "$DOTPATH/configs/sh/common_rc.sh"
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit
prompt clint

if [ -r "$DOTPATH/configs/zsh/local.zsh" ]; then
    . "$DOTPATH/configs/zsh/local.zsh"
fi
