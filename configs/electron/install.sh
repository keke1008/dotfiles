#!/bin/sh -eu

for version in 27 28; do
	stash_and_link \
		"electron" \
		"${XDG_CONFIG_HOME}/electron${version}-flags.conf" \
		"electron-flags.conf" \
		"electron${version}-flags.conf"
done
