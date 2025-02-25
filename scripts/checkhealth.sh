#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/log.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"

report() {
	if [ $# -ne 2 ] && [ $# -ne 3 ]; then
		abort "Usage: report level message [detail]"
	fi

	local level="$1"
	local message="$2"
	local detail="${3:-""}"

	local color
	case ${level} in
	trace) color="green" ;;
	info) color="blue" ;;
	warn) color="yellow" ;;
	error) color="red" ;;
	*) abort "Invalid level: ${level}" ;;
	esac

	printf "\t%s\n" "$(print_colored "${color}" " ${message}")"

	if [ -n "${detail}" ] && [ "${level}" != "trace" ]; then
		printf "\t\t%s\n" "${detail}"
	fi
}

report_command_exists() {
	if [ $# -ne 2 ] && [ $# -ne 3 ]; then
		abort "Usage: report_command_exists level command [detail]"
	fi

	local level="$1"
	local command="$2"
	local detail="${3:-""}"

	if command -v "${command}" >/dev/null 2>&1; then
		report "trace" "Command found: ${command}" "${detail}"
	else
		report "${level}" "Command not found: ${command}" "${detail}"
	fi
}

report_file_readable() {
	if [ $# -ne 2 ] && [ $# -ne 3 ]; then
		abort "Usage: report_file_readable level file_path [detail]"
	fi

	local level="$1"
	local file_path="$2"
	local detail="${3:-""}"

	if [ ! -f "${file_path}" ]; then
		report "${level}" "File does not exist: ${file_path}" "${detail}"
	elif [ -r "${file_path}" ]; then
		report "trace" "File is readable: ${file_path}" "${detail}"
	else
		report "${level}" "File is not readable: ${file_path}" "${detail}"
	fi
}

report_file_executable() {
	if [ $# -ne 2 ] && [ $# -ne 3 ]; then
		abort "Usage: report_file_executable level file_path [detail]"
	fi

	local level="$1"
	local file_path="$2"
	local detail="${3:-""}"

	if [ ! -f "${file_path}" ]; then
		report "${level}" "File does not exist: ${file_path}" "${detail}"
	elif [ -x "${file_path}" ]; then
		report "trace" "File is executable: ${file_path}" "${detail}"
	else
		report "${level}" "File is not executable: ${file_path}" "${detail}"
	fi
}

run_checkhealth_single_config() {
	if [ $# -ne 1 ]; then
		abort "Usage: checkhealth_single_config config_dir"
	fi
	local config_dir="$1"

	local checkhealth_script="${config_dir}/checkhealth.sh"
	if [ ! -e "${checkhealth_script}" ]; then
		return
	fi

	print_colored "cyan" " $(basename "${config_dir}")\n"
	if [ ! -r "${checkhealth_script}" ]; then
		print_colored red "\tError: ${checkhealth_script} is not readable\n\n"
		return
	fi

	# shellcheck disable=SC1090
	. "${checkhealth_script}"
}

main() {
	local config_dirnames
	config_dirnames=$(enumerate_config_dirname "$@" | filter_file_exists "checkhealth.sh")

	local config_dirname
	for config_dirname in ${config_dirnames}; do
		run_checkhealth_single_config "$(config_dirname_to_path "${config_dirname}")"
	done

	exit_with_stored_code
}

main "$@"
