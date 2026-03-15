#!/bin/sh -eu

if ! command -v quickshell >/dev/null 2>&1; then
	log warn "quickshell is not installed. Please install quickshell to use this service."
	return 0
fi

enable_systemd_unit_dir
