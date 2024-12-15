#!/usr/bin/env bats

@test "can install executable file" {
	local DIFF_TOOL_FILENAME="dotfiles-git-diff-tool"
	local DEST="${HOME}/.local/bin/${DIFF_TOOL_FILENAME}"
	local SRC="${DOTPATH}/configs/git/bin/${DIFF_TOOL_FILENAME}"

	run "${DOTPATH}/dot" install git
	[ "${status}" -eq 0 ]
	[ "$(readlink "${DEST}")" = "${SRC}" ]
}
