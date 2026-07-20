#!/bin/sh -eu

. "${_DOTFILES_SCRIPT_HOME}/lib/log.sh"
. "${_DOTFILES_SCRIPT_HOME}/lib/migration.sh"
. "${_DOTFILES_SCRIPT_HOME}/lib/placement.sh"

main() {
	if ! migrate_dotfiles; then
		log "error" "Failed to run migration. Exiting installation"
		exit 1
	fi

	local specified_placement_groups
	if ! specified_placement_groups="$(guess_specified_placement_groups "$@")"; then
		abort 'Invalid placement_groups'
	fi

	local handling_group_names placement_entries_path
	placement_entries_path="$(mktemp)"
	trap 'rm -f "${placement_entries_path}"' EXIT

	if ! handling_group_names="$(
		evaluate_placement_entries \
			"${placement_entries_path}" \
			"${placement_entries_path}" \
			"${specified_placement_groups}"
	)"; then
		abort 'Failed to evaluate placement_entries'
	fi

	sort -u -o "${placement_entries_path}" "${placement_entries_path}"

	while IFS= read -r placement_entry; do
		if ! unapply_placement_entry "${placement_entry}"; then
			log 'error' "Failed to unapply placement_entry ${placement_entry}"
		fi
	done <"${placement_entries_path}"

	log 'info' 'Unlocking placement_entries'
	for group_name in ${handling_group_names}; do
		if ! unlock_placement_entries "${group_name}"; then
			log 'error' "Failed to unlock placement_entries: ${group_name}"
		fi
	done

	exit_with_stored_code
}

main "$@"
