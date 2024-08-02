#!/usr/bin/env bats

@test "can install and restore .tmux.conf" {
	local ORIGINAL_TMUX_CONF_CONTENTS="# Original .tmux.conf contents"
	echo "${ORIGINAL_TMUX_CONF_CONTENTS}" >"${HOME}/.tmux.conf"

	run "${DOTPATH}/dot" install tmux
	[ "${status}" -eq 0 ]
	[ "$(readlink "${HOME}/.tmux.conf")" = "${DOTPATH}/configs/tmux/.tmux.conf" ]

	run "${DOTPATH}/dot" restore tmux
	[ "${status}" -eq 0 ]
	[ "$(cat "${HOME}/.tmux.conf")" = "${ORIGINAL_TMUX_CONF_CONTENTS}" ]
}
