#!/usr/bin/env bats

@test "can instal and restore fish function" {
	local ORIGINAL_FUNCTION_CONTENTS="# Original fish/functions/_installation_test.fish contents"
	local ORIGINAL_FUNCTION_PATH="${XDG_CONFIG_HOME}/fish/functions/_installation_test.fish"
	local DOTFILES_FUNCTION_PATH="${DOTPATH}/configs/fish/fish/functions/_installation_test.fish"

	mkdir -p "${XDG_CONFIG_HOME}/fish/functions"
	echo "${ORIGINAL_FUNCTION_CONTENTS}" >"${ORIGINAL_FUNCTION_PATH}"

	run "${DOTPATH}/dot" install fish
	[ "${status}" -eq 0 ]
	[ "$(readlink -f "${ORIGINAL_FUNCTION_PATH}")" = "${DOTFILES_FUNCTION_PATH}" ]

	run "${DOTPATH}/dot" restore fish
	[ "${status}" -eq 0 ]
	[ "$(cat "${ORIGINAL_FUNCTION_PATH}")" = "${ORIGINAL_FUNCTION_CONTENTS}" ]
}
