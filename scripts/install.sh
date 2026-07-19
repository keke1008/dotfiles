#!/bin/sh -eu

. "${_DOTFILES_SCRIPT_HOME}/lib/log.sh"
. "${_DOTFILES_SCRIPT_HOME}/lib/migration.sh"
. "${_DOTFILES_SCRIPT_HOME}/lib/placement.sh"

main() {
	if ! migrate_dotfiles; then
		abort 'Failed to run migration. Exiting installation'
	fi

	local specified_placement_groups
	if ! specified_placement_groups="$(guess_specified_placement_groups "$@")"; then
		abort 'invalid placement_groups'
	fi

	log 'info' "Evaluating placement_entries: ${specified_placement_groups}"
	local handling_group_names declared_placement_entries_path locked_placement_entries_path
	declared_placement_entries_path="$(mktemp)"
	trap 'rm -f "${declared_placement_entries_path}"' EXIT
	locked_placement_entries_path="$(mktemp)"
	trap 'rm -f "${locked_placement_entries_path}"' EXIT

	if ! handling_group_names="$(
		evaluate_placement_entries \
			"${declared_placement_entries_path}" \
			"${locked_placement_entries_path}" \
			"${specified_placement_groups}"
	)"; then
		abort 'Failed to evaluate placement_entries'
	fi

	sort -o "${declared_placement_entries_path}" "${declared_placement_entries_path}"
	sort -o "${locked_placement_entries_path}" "${locked_placement_entries_path}"

	# Only exists in $locked_placement_entries_path
	comm -13 "${declared_placement_entries_path}" "${locked_placement_entries_path}" |
		while IFS= read -r placement_entry; do
			unapply_placement_entry "${placement_entry}"
		done

	# Exists in $declared_placement_entries_path and $locked_placement_entries
	comm -12 "${declared_placement_entries_path}" "${locked_placement_entries_path}" |
		while IFS= read -r placement_entry; do
			apply_placement_entry "${placement_entry}"
		done

	# Only exists in $declared_placement_entries_path
	comm -23 "${declared_placement_entries_path}" "${locked_placement_entries_path}" |
		while IFS= read -r placement_entry; do
			apply_placement_entry "${placement_entry}"
		done

	log 'info' 'Locking placement_entries'
	for group_name in ${handling_group_names}; do
		local declared_entries
		declared_entries="$(list_declared_placement_entries "${group_name}")"
		if ! lock_placement_entries "${group_name}" "${declared_entries}"; then
			log 'error' "Failed to lock placement_entries: ${group_name}"
		fi
	done

	exit_with_stored_code
}

main "$@"
