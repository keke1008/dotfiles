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
		mkdir -p "${code_dir}"
		declare_config_link "${code_dir}/keybindings.json" "keybindings.json" "${code_dirname}-keybindings.json"
		declare_config_link "${code_dir}/settings.json" "settings.json" "${code_dirname}-settings.json"
	done

	# for remote development
	if [ -n "${SSH_CLIENT:-''}" ] || [ -n "${SSH_TTY:-''}" ]; then # Use parameter expansion to prevent an 'undefined variable' error
		for server_dirname in ".vscode-server" ".cursor-server"; do
			local server_dir="${HOME}/${server_dirname}/data/Machine"
			mkdir -p "${server_dir}"
			declare_config_link "${server_dir}/settings.json" "settings.json" "remote-settings.json"
		done
	fi
}

main
