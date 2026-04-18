#!/bin/sh -eu

. "${_DOTFILES_SCRIPT_HOME}/lib/log.sh"
. "${_DOTFILES_SCRIPT_HOME}/lib/config_directory.sh"

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

		local init_script
		init_script="$(config_dirname_to_path "${config_dirname}")/init.sh"
		if [ ! -f "${init_script}" ]; then
			log "error" "No init.sh found in ${config_dirname}"
			set_exit_code 1
			continue
		fi

		export DOTFILES_INIT_CONFIG_NAME="${config_dirname}"
		# shellcheck disable=SC1090
		if ! . "${init_script}"; then
			set_exit_code 1
			continue
		fi
	done

	exit_with_stored_code
}

main "$@"
