#!/bin/sh

if ! command -v fish >/dev/null 2>&1; then
	log "warn" "Fish shell is not installed."
	return 0
fi

if fish -c "type -q fisher"; then
	log "info" "Fisher is already installed"
	return
fi

if ! fish -c "type -q curl"; then
	log "error" "curl is not installed. Curl is required to install Fisher."
	return 1
fi

log "info" "Installing Fisher plugins"
if ! fish -c "curl -sL https://git.io/fisher | source && fisher update"; then
	log "error" "Failed to install Fisher plugins"
	return 1
fi

log "info" "Fisher installation complete"
