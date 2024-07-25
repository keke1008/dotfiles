#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/abort.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"
. "${DOTPATH}/scripts/lib/install.sh"

main() {
	local config_dirnames
	config_dirnames="$(enumerate_config_dirname "$@")"
	if ! echo "$config_dirnames" | check_file_exists "install.sh"; then
		abort "Some configuration directories do not have valid install.sh"
	fi

	local config_dirname
	# shellcheck disable=SC2167
	for config_dirname in $config_dirnames; do
		create_original_home "${config_dirname}"

		# shellcheck disable=SC1090
		if ! . "$(config_dirname_to_path "${config_dirname}")/install.sh"; then
			echo "Failed to install configuration directory: ${config_dirname}" >&2
			continue
		fi

		mark_stashed "${config_dirname}"
	done
}

main "$@"
