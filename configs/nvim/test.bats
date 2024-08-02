#!/usr/bin/env bats

@test "can install and restore nvim" {
	local ORIGINAL_NVIM_INIT_LUA_CONTENTS="# Original nvim/init.lua contents"
	mkdir -p "${HOME}/.config/nvim"
	echo "${ORIGINAL_NVIM_INIT_LUA_CONTENTS}" >"${HOME}/.config/nvim/init.lua"

	run "${DOTPATH}/dot" install nvim
	[ "${status}" -eq 0 ]
	[ "$(readlink "${HOME}/.config/nvim")" = "${DOTPATH}/configs/nvim/nvim" ]

	run "${DOTPATH}/dot" restore nvim
	[ "${status}" -eq 0 ]
	[ "$(cat "${HOME}/.config/nvim/init.lua")" = "${ORIGINAL_NVIM_INIT_LUA_CONTENTS}" ]
}
