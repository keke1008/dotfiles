#!/bin/sh -eu

if [ -d "${HOME}/.tmux/plugins/tpm" ]; then
	log "info" "TPM is already installed."
	return
fi

if ! command -v tmux >/dev/null 2>&1; then
	log "error" "tmux is not installed."
	return
fi

if ! command -v git >/dev/null 2>&1; then
	log "error" "Git is not installed. Git is required to install TPM."
	return
fi

log "info" "Installing TPM"
if ! git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"; then
	log "error" "Failed to install TPM"
	return
fi

log "info" "Loading TPM"
if ! "$HOME/.tmux/plugins/tpm/tpm"; then
	log "error" "Failed to load TPM"
	return
fi

log "info" "Installing TPM plugins"
if ! "$HOME/.tmux/plugins/tpm/bin/install_plugins"; then
	log "error" "Failed to install TPM plugins"
	return
fi

log "info" "TPM installation complete"
