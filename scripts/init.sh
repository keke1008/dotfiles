#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/log.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"

run_single() {
	if [ $# -ne 1 ]; then
		abort "Usage: run_single <config_dir_path>"
	fi

	local init_script="${1}/init.sh"
	if [ ! -f "${init_script}" ]; then
		abort "No init.sh found in ${1}"
	fi

	# shellcheck disable=SC1090
	if ! . "${init_script}"; then
		set_exit_code 1
	fi
}

main() {
	if [ $# -gt 1 ]; then
		abort "Usage: $0 [config_dir_path]"
	fi

	local config_dirnames
	if [ $# -eq 1 ]; then
		config_dirnames="$1"
	else
		config_dirnames="$(enumerate_config_dirname | filter_file_exists "init.sh")"
	fi

	local config_dirname
	for config_dirname in ${config_dirnames}; do
		log "info" "Running init script for: ${config_dirname}"
		run_single "$(config_dirname_to_path "${config_dirname}")"
	done

	exit_with_stored_code
}

main "$@"
