# shellcheck shell=sh

enumerate_config_directory() {
	if [ $# -eq 0 ]; then
		enumerated_directory_paths="${DOTPATH}/configs/*"
	else
		enumerated_directory_paths="$*"
	fi

	for dir in $enumerated_directory_paths; do
		enumerated_directory_dirname=$(basename "${dir}")
		enumerated_directory_path="${DOTPATH}/configs/${enumerated_directory_dirname}"

		if [ ! -d "${enumerated_directory_path}" ]; then
			echo "Unknown configuration directory: ${enumerated_directory_dirname}" >&2
			return 1
		fi

		echo "${enumerated_directory_path}"
	done
}

check_file_exists() {
	is_all_file_exists=0
	while read -r dir; do
		for check_filename in "$@"; do
			if [ ! -f "${dir}/${check_filename}" ]; then
				echo "File not found: ${dir}/${check_filename}" >&2
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
			if [ ! -r "${dir}/${check_filename}" ]; then
				echo "File not readable: ${dir}/${check_filename}" >&2
				is_all_file_readable=1
			fi
		done
	done

	return $is_all_file_readable
}

filter_file_exists() {
	while read -r dir; do
		for filter_filename in "$@"; do
			if [ -f "${dir}/${filter_filename}" ]; then
				echo "${dir}"
			fi
		done
	done
}

filter_file_readable() {
	while read -r dir; do
		for filter_filename in "$@"; do
			if [ -r "${dir}/${filter_filename}" ]; then
				echo "${dir}"
			fi
		done
	done
}
