#!/bin/sh -eu

if ! command -v batsignal >/dev/null 2>&1; then
	log warn "batsignal is not installed. Please install eww to use this service."
	return 0
fi

enable_systemd_unit_dir
