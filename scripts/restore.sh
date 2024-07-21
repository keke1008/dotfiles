#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/abort.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"
. "${DOTPATH}/scripts/lib/install.sh"

main() {
	local config_dirs
	config_dirs="$(enumerate_config_directory "$@" | filter_file_exists "restore.sh")"
	# shellcheck disable=SC2167
	for config_directory in $config_dirs; do
		# shellcheck disable=SC1090
		. "${config_directory}/restore.sh"
	done
}

main "$@"
