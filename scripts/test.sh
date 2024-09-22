#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/log.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"

main() {
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
}

main "$@"
