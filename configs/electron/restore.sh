#!/bin/sh -eu

for version in 27 28; do
	unlink_and_restore \
		"electron" \
		"${XDG_CONFIG_HOME}/electron${version}-flags.conf" \
		"electron${version}-flags.conf"
done
