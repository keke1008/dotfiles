#!/bin/sh -eu

. "${_DOTFILES_SCRIPT_HOME}/lib/log.sh"
. "${_DOTFILES_SCRIPT_HOME}/lib/config_directory.sh"
. "${_DOTFILES_SCRIPT_HOME}/lib/migration.sh"

main() {
	if ! is_latest_version; then
		log "error" "Please migrate to the latest version first"
		exit 1
	fi

	if ! command -v bats >/dev/null; then
		abort "bats is not installed"
	fi

	local config_dirnames
	config_dirnames="$(
		enumerate_config_dirname "$@" |
			filter_file_exists "test.bats" |
			map_config_dirname_to_file_path "test.bats"
	)"

	# shellcheck disable=SC2086
	bats $config_dirnames

	exit_with_stored_code
}

main "$@"
