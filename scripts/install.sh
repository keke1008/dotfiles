#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/abort.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"
. "${DOTPATH}/scripts/lib/install.sh"

main() {
	config_directories=$(enumerate_config_directory "$@")
	if ! echo "$config_directories" | check_file_exists "install.sh"; then
		abort "Some configuration directories do not have valid install.sh"
	fi

	# shellcheck disable=SC2167
	for config_directory in $config_directories; do
		# shellcheck disable=SC1090
		. "${config_directory}/install.sh"
	done
}

main "$@"
