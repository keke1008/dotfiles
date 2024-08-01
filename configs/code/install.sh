#!/bin/sh -eu

main() {
	local src_dir="${DOTPATH}/configs/code"

	if [ "$(uname)" = "Darwin" ]; then
		local code_base_dir="${HOME}/Library/Application Support"
	else
		local code_base_dir="${XDG_CONFIG_HOME}"
	fi

	local code_dirname
	for code_dirname in "Code - OSS" "Code"; do
		local code_dir="${code_base_dir}/${code_dirname}/User"
		mkdir -p "${code_dir}"
		declare_config_link "${code_dir}/keybindings.json" "keybindings.json" "${code_dirname}-keybindings.json"
		declare_config_link "${code_dir}/settings.json" "settings.json" "${code_dirname}-settings.json"
	done

	# for remote development
	if [ -n "${SSH_CLIENT:-''}" ] || [ -n "${SSH_TTY:-''}" ]; then # Use parameter expansion to prevent an 'undefined variable' error
		local vscode_server_dir="${HOME}/.vscode-server/data/Machine"
		mkdir -p "${vscode_server_dir}"
		declare_config_link "${vscode_server_dir}/settings.json" "settings.json" "remote-settings.json"
	fi
}

main
