#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/log.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"
. "${DOTPATH}/scripts/lib/install.sh"

declare_config_link() {
	stash_and_link "${DOTFILES_INSTALL_CONFIG_NAME}" "$@"
}

declare_xdg_config_link() {
	stash_and_link_xdg_based_config "${DOTFILES_INSTALL_CONFIG_NAME}" "$@"
}

declare_home_config_link() {
	stash_and_link_home_config "${DOTFILES_INSTALL_CONFIG_NAME}" "$@"
}

main() {
	export DOTFILES_INSTALL_MODE="install"

	local config_dirnames
	config_dirnames="$(enumerate_config_dirname "$@")"
	if ! echo "$config_dirnames" | check_file_exists "install.sh"; then
		abort "Some configuration directories do not have valid install.sh"
	fi

	local config_dirname
	# shellcheck disable=SC2167
	for config_dirname in $config_dirnames; do
		DOTFILES_INSTALL_CONFIG_NAME="${config_dirname}"
		create_original_home "${config_dirname}"

		# shellcheck disable=SC1091
		if ! . "$(config_dirname_to_path "${config_dirname}")/install.sh"; then
			log "error" "Failed to install configuration directory: ${config_dirname}"
			continue
		fi

		mark_installed "${config_dirname}"
	done
}

main "$@"
