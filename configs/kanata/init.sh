#!/bin/sh -eu

if ! command -v kanata >/dev/null 2>&1; then
	log warn "kanata is not installed. Please install kanata to use this service."
	return 0
fi

enable_systemd_unit_dir
