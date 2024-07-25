#!/bin/sh -eu

for version in 3.0 4.0; do
	mkdir -p "$XDG_CONFIG_HOME/gtk-${version}"
	stash_and_link \
		"gtk" \
		"${XDG_CONFIG_HOME}/gtk-${version}/settings.ini" \
		"gtk-${version}-settings.ini"
done
