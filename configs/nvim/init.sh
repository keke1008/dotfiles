#!/bin/sh -eu

if ! command -v nvim >/dev/null 2>&1; then
	log "error" "Neovim is not installed."
	return
fi

if "$(nvim --headless -c '=require("keke.lazy").exit_with_is_installed()')"; then
	log "info" "Neovim plugin manager is already installed."
	return
fi

if ! command -v git >/dev/null 2>&1; then
	log "error" "Git is not installed. Git is required to install Neovim plugin manager."
	return
fi

log "info" "Installing Neovim plugin manager"
if ! nvim --headless -c 'lua require("keke.lazy").exit_with_bootstrap()'; then
	log "error" "Failed to install Neovim plugin manager."
	return
fi

log "info" "Neovim plugin manager installed successfully."
