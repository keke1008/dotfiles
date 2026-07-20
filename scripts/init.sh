#!/bin/sh -eu

. "${_DOTFILES_SCRIPT_HOME}/lib/log.sh"
. "${_DOTFILES_SCRIPT_HOME}/lib/placement.sh"

main() {
	local specified_placement_groups
	if ! specified_placement_groups="$(guess_specified_placement_groups "$@")"; then
		abort 'Invalid placement_groups'
	fi

	local group_name
	for group_name in ${specified_placement_groups}; do
		local init_script_path
		init_script_path="$(resolve_initialize_script_path "${group_name}")"
		if ! [ -r "${init_script_path}" ]; then
			continue
		fi

		log "info" "Running init script: ${group_name}"
		# shellcheck disable=SC1090
		if ! . "${init_script_path}"; then
			log 'error' "Failed to execute initialize script: ${init_script_path}"
			set_exit_code 1
			continue
		fi
	done

	exit_with_stored_code
}

main "$@"
