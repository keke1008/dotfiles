#!/usr/bin/env bats

@test "can install and restore starship.toml" {
	local ORIGINAL_STARSHIP_TOML_CONTENTS="# Original starship.toml contents"
	echo "${ORIGINAL_STARSHIP_TOML_CONTENTS}" >"${XDG_CONFIG_HOME}/starship.toml"

	run "${DOTPATH}/dot" install starship
	[ "${status}" -eq 0 ]
	[ "$(readlink "${XDG_CONFIG_HOME}/starship.toml")" = "${DOTPATH}/configs/starship/starship.toml" ]

	run "${DOTPATH}/dot" restore starship
	[ "${status}" -eq 0 ]
	[ "$(cat "${XDG_CONFIG_HOME}/starship.toml")" = "${ORIGINAL_STARSHIP_TOML_CONTENTS}" ]
}
