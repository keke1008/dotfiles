#!/bin/sh

if ! command -v sway >/dev/null 2>&1; then
	log warn "sway is not installed. Skipping enabling sway services."
	return 0
fi

if command -v swaync >/dev/null 2>&1; then
	enable_systemd_unit "swaync.service"
else
	log warn "swaync is not installed. Skipping enabling swaync.service."
fi

# Hyprpolkitagent does not provide binary named hyprpolkitagent so we just try to enable the service and see if it works.
if ! enable_systemd_unit "hyprpolkitagent.service"; then
	log warn "Failed to enable hyprpolkitagent.service. Do you have hyprpolkitagent installed?"
	return 0
fi
