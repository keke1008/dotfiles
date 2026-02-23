#!/bin/sh -eu

. "${DOTFILES_SCRIPT_HOME}/lib/log.sh"
. "${DOTFILES_SCRIPT_HOME}/lib/link_reproducible.sh"
. "${DOTFILES_SCRIPT_HOME}/lib/config_directory.sh"
. "${DOTFILES_SCRIPT_HOME}/lib/install.sh"
. "${DOTFILES_SCRIPT_HOME}/lib/migration.sh"

declare_config_link() {
	unlink_and_restore "${DOTFILES_RESTORE_CONFIG_NAME}" "$@"
}

declare_xdg_config_link() {
	unlink_and_restore_xdg_based_config "${DOTFILES_RESTORE_CONFIG_NAME}" "$@"
}

declare_home_config_link() {
	unlink_and_restore_home_config "${DOTFILES_RESTORE_CONFIG_NAME}" "$@"
}

declare_local_bin_link() {
	unlink_local_bin "${DOTFILES_RESTORE_CONFIG_NAME}" "$@"
}

declare_local_bin_dir_link() {
	unlink_local_bin_dir "${DOTFILES_RESTORE_CONFIG_NAME}" "$@"
}

declare_systemd_unit_dir_link() {
	unlink_systemd_unit_dir "${DOTFILES_RESTORE_CONFIG_NAME}" "$@"
}

main() {
	if ! migrate_dotfiles; then
		log "error" "Failed to run migration. Exiting installation"
		exit 1
	fi

	export DOTFILES_INSTALL_MODE="restore"

	local config_dirnames
	config_dirnames="$(enumerate_config_dirname "$@")"
	if ! echo "$config_dirnames" | check_file_exists "install.sh"; then
		abort "Some configuration directories do not have valid install.sh"
	fi

	local config_dirname
	# shellcheck disable=SC2167
	for config_dirname in $config_dirnames; do
		DOTFILES_RESTORE_CONFIG_NAME="${config_dirname}"

		log "info" "Restoring configuration directory: ${config_dirname}"

		# shellcheck disable=SC1091
		if ! . "$(config_dirname_to_path "${config_dirname}")/install.sh"; then
			log "error" "Failed to restore configuration directory: ${config_dirname}"
		fi
	done

	exit_with_stored_code
}

main "$@"
