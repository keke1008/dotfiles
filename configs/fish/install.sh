#!/bin/sh -eu

main() {
	mkdir -p "${XDG_CONFIG_HOME}/fish"
	# ln -snfv "$DOTPATH/configs/fish/config.fish" "$FISH_CONFIG_DIR"
	stash_and_link "fish" "${XDG_CONFIG_HOME}/fish/config.fish" "config.fish"

	local dir
	for dir in "functions" "themes"; do
		mkdir -p "${XDG_CONFIG_HOME}/fish/${dir}"

		local file
		for file in $(find "${DOTPATH}/configs/fish/${dir}" -type f); do
			local name
			name="$(basename "${file}")"
			stash_and_link "fish" "${XDG_CONFIG_HOME}/fish/${dir}/${name}" "${dir}/${name}"
		done
	done
}

main
