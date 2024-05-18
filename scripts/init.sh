#!/bin/sh
# Init settings used for installation and individual tools

export XDG_CONFIG_HOME="${HOME}/.config"
export DOTFILES_CONFIG_HOME="${XDG_CONFIG_HOME}/dotfiles"
export DOTFILES_LOCAL_HOME="${DOTFILES_CONFIG_HOME}/local"

mkdir -p "${DOTFILES_LOCAL_HOME}"
if command -v "git" >/dev/null 2>&1 && [ ! -d "$DOTFILES_CONFIG_HOME/.git" ]; then
	git init "${DOTFILES_CONFIG_HOME}"
fi
