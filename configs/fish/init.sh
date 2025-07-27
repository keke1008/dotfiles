#!/bin/sh

if ! command -v fish >/dev/null 2>&1; then
	log "error" "Fish shell is not installed."
	return 1
fi

if fish -c "type -q fisher"; then
	log "info" "Fisher is already installed"
	return
fi

log "info" "Installing Fisher"
if ! fish -c "curl -sL https://git.io/fisher | source"; then
	log "error" "Failed to install Fisher"
	return 1
fi

log "info" "Installing Fisher plugins"
if ! fish -c "fisher update"; then
	log "error" "Failed to install Fisher plugins"
	return 1
fi

log "info" "Fisher installation complete"
