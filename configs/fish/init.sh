#!/bin/sh

if ! command -v fish >/dev/null 2>&1; then
	log "error" "Fish shell is not installed."
	return
fi

if fish -c "type -q fisher"; then
	log "info" "Fisher is already installed"
	return
fi

log "info" "Installing Fisher"
fish -c "curl -sL https://git.io/fisher | source"

log "info" "Installing Fisher plugins"
fish -c "fisher update"

log "info" "Fisher installation complete"
