# shellcheck shell=sh
#
# requirements:
#  ./log.sh

config_dirname_to_path() {
	if [ $# -ne 1 ]; then
		abort "Usage: config_dirname_to_path <config_dirname>"
	fi

	echo "${_DOTFILES_CONFIG_HOME}/${1}"
}

map_config_dirname_to_file_path() {
	if [ $# -ne 1 ]; then
		abort "Usage: map_config_dirname_to_file_path <filename>"
	fi

	local filename="${1}"

	local dir
	while read -r dir; do
		echo "$(config_dirname_to_path "${dir}")/${filename}"
	done
}

enumerate_config_dirname() {
	local dir_paths
	if [ $# -eq 0 ]; then
		dir_paths="${_DOTFILES_CONFIG_HOME}/*"
	else
		dir_paths="$*"
	fi

	local dir
	for dir in $dir_paths; do
		local config_dirname
		config_dirname="$(basename "${dir}")"
		local config_dir_path
		config_dir_path="$(config_dirname_to_path "${config_dirname}")"

		if [ ! -d "${config_dir_path}" ]; then
			abort "Unknown configuration directory: ${config_dir_path}"
		fi

		echo "${config_dirname}"
	done
}

check_file_exists() {
	local is_all_file_exists=0
	local dir
	while read -r dir; do
		local check_filename
		for check_filename in "$@"; do
			local check_file_path
			check_file_path="$(config_dirname_to_path "${dir}")/${check_filename}"
			if [ ! -f "${check_file_path}" ]; then
				log "info" "File not found: ${check_file_path}"
				is_all_file_exists=1
			fi
		done
	done

	return $is_all_file_exists
}

check_file_readable() {
	local is_all_file_readable=0
	local dir
	while read -r dir; do
		local check_filename
		for check_filename in "$@"; do
			local check_file_path
			check_file_path="$(config_dirname_to_path "${dir}")/${check_filename}"
			if [ ! -r "${check_file_path}" ]; then
				log "info" "File not readable: ${check_file_path}"
				is_all_file_readable=1
			fi
		done
	done

	return $is_all_file_readable
}

filter_file_exists() {
	local dir
	while read -r dir; do
		local filter_filename
		for filter_filename in "$@"; do
			if [ -f "$(config_dirname_to_path "${dir}")/${filter_filename}" ]; then
				echo "${dir}"
			fi
		done
	done
}

filter_file_readable() {
	local dir
	while read -r dir; do
		local filter_filename
		for filter_filename in "$@"; do
			if [ -r "$(config_dirname_to_path "${dir}")/${filter_filename}" ]; then
				echo "${dir}"
			fi
		done
	done
}
