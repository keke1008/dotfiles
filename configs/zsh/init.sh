#!/bin/sh -eu

if [ -d "${XDG_CONFIG_HOME}/.antidote" ]; then
	log info "Antidote is already installed"
	return
fi

if ! command -v zsh >/dev/null 2>&1; then
	log error "Zsh is not installed."
	return 1
fi

if ! command -v git >/dev/null 2>&1; then
	log error "Git is not installed. Git is required to install Antidote."
	return 1
fi

log info "Installing Antidote"
if ! git clone https://github.com/mattmc3/antidote "${XDG_DATA_HOME}/.antidote"; then
	log error "Failed to install Antidote"
	return 1
fi

log info "Installing Antidote plugins"
if ! zsh -c 'source "${XDG_DATA_HOME}/.antidote/antidote.zsh" && antidote load'; then
	log error "Failed to install Antidote plugins"
	return 1
fi

log info "Antidote plugins installed successfully"
