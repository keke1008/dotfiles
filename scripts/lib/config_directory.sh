# shellcheck shell=sh

config_dirname_to_path() {
	if [ $# -ne 1 ]; then
		echo "Usage: config_dirname_to_path <config_dirname>" >&2
		return 1
	fi

	echo "${DOTPATH}/configs/${1}"
}

enumerate_config_dirname() {
	local dir_paths
	if [ $# -eq 0 ]; then
		dir_paths="${DOTPATH}/configs/*"
	else
		dir_paths="$*"
	fi

	for dir in $dir_paths; do
		local config_dirname
		config_dirname="$(basename "${dir}")"
		local config_dir_path
		config_dir_path="$(config_dirname_to_path "${config_dirname}")"

		if [ ! -d "${config_dir_path}" ]; then
			echo "Unknown configuration directory: ${config_dir_path}" >&2
			return 1
		fi

		echo "${config_dirname}"
	done
}

check_file_exists() {
	is_all_file_exists=0
	while read -r dir; do
		for check_filename in "$@"; do
			local check_file_path
			check_file_path="$(config_dirname_to_path "${dir}")/${check_filename}"
			if [ ! -f "${check_file_path}" ]; then
				echo "File not found: ${check_file_path}" >&2
				is_all_file_exists=1
			fi
		done
	done

	return $is_all_file_exists
}

check_file_readable() {
	is_all_file_readable=0
	while read -r dir; do
		for check_filename in "$@"; do
			local check_file_path
			check_file_path="$(config_dirname_to_path "${dir}")/${check_filename}"
			if [ ! -r "${check_file_path}" ]; then
				echo "File not readable: ${check_file_path}" >&2
				is_all_file_readable=1
			fi
		done
	done

	return $is_all_file_readable
}

filter_file_exists() {
	while read -r dir; do
		for filter_filename in "$@"; do
			if [ -f "$(config_dirname_to_path "${dir}")/${filter_filename}" ]; then
				echo "${dir}"
			fi
		done
	done
}

filter_file_readable() {
	while read -r dir; do
		for filter_filename in "$@"; do
			if [ -r "$(config_dirname_to_path "${dir}")/${filter_filename}" ]; then
				echo "${dir}"
			fi
		done
	done
}
