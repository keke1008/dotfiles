#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/abort.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"
. "${DOTPATH}/scripts/lib/install.sh"

main() {
	local config_dirnames
	config_dirnames="$(enumerate_config_dirname "$@" | filter_file_exists "restore.sh")"

	local config_dirname
	# shellcheck disable=SC2167
	for config_dirname in $config_dirnames; do
		# shellcheck disable=SC1090
		. "$(config_dirname_to_path "${config_dirname}")/restore.sh"
	done
}

main "$@"
