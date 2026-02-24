#!/bin/sh -eu

main() {
	if [ "$(uname)" = "Darwin" ]; then
		local code_base_dir="${HOME}/Library/Application Support"
	else
		local code_base_dir="${XDG_CONFIG_HOME}"
	fi

	local code_dirname
	for code_dirname in "Code - OSS" "Code" "Cursor"; do
		local code_dir="${code_base_dir}/${code_dirname}/User"
		declare_config_link "${code_dirname}/keybindings.json" "${code_dir}/keybindings.json"
		declare_config_link "${code_dirname}/settings.json" "${code_dir}/settings.json"
	done
}

main
