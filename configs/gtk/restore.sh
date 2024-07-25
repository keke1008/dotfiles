#!/bin/sh -eu

for version in 3.0 4.0; do
	mkdir -p "$XDG_CONFIG_HOME/gtk-${version}"
	unlink_and_restore \
		"gtk" \
		"${XDG_CONFIG_HOME}/gtk-${version}/settings.ini" \
		"gtk-${version}-settings.ini"
done
