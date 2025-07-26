#!/bin/sh -eu

if [ -d "${XDG_CONFIG_HOME}/.antidote" ]; then
	log info "Antidote is already installed"
	return
fi

if ! command -v zsh >/dev/null 2>&1; then
	log error "Zsh is not installed."
	return
fi

if ! command -v git >/dev/null 2>&1; then
	log error "Git is not installed. Git is required to install Antidote."
	return
fi

log info "Installing Antidote"
git clone https://github.com/mattmc3/antidote "${XDG_DATA_HOME}/.antidote"

log info "Installing Antidote plugins"
cat <<EOS | zsh
source "${XDG_DATA_HOME}/.antidote/antidote.zsh"
antidote load
EOS

log info "Antidote installation complete"
