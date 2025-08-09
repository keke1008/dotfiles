# shellcheck shell=sh
# Rename local configuration files

rename() {
	if [ "$#" -ne 2 ]; then
		echo "Usage: rename <target_path> <new_file_name>"
		return 1
	fi

	local target_path="${DOTFILES_LOCAL_HOME}/$1"
	local new_file_name="$2"

	if ! [ -e "${target_path}" ]; then
		log "info" "File not found: ${target_path}. Skipping rename."
		return 0
	fi

	if [ -e "${target_path}/${new_file_name}" ]; then
		log "warn" "File already exists: ${target_path}/${new_file_name}. Skipping rename."
		return 0
	fi

	local target_dirname
	if ! target_dirname="$(dirname "${target_path}")"; then
		log "error" "Failed to get directory name for: ${target_path}"
		return 1
	fi

	if ! mv "${target_path}" "${target_dirname}/${new_file_name}"; then
		log "error" "Failed to rename ${target_path} to ${target_dirname}/${new_file_name}"
		return 1
	fi

	log "info" "Renamed ${target_path} to ${target_dirname}/${new_file_name}"
	return 0
}

main() {
	rename "alacritty/local_config.toml" "alacritty.toml"
	rename "bash/local_rc.sh" ".bashrc"
	rename "fish/local_config.fish" "config.fish"
	rename "git/local_config" "config"
	rename "sh/local_profile.sh" ".profile"
	rename "sh/local_rc.sh" ".shrc"
	rename "sway/local_config" "config"
	rename "zsh/local_rc.sh" ".zshrc"
}

main
