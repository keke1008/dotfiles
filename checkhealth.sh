#!/bin/bash -eu
#

abort() {
	echo "Error: " "$@"
	exit 1
}

print_colored() {
	if [ $# -ne 2 ]; then
		abort "Usage: print_colored color text"
	fi

	local color=$1
	local text=$2

	local id
	case ${color} in
	red) id="31" ;;
	green) id="32" ;;
	yellow) id="33" ;;
	blue) id="34" ;;
	magenta) id="35" ;;
	cyan) id="36" ;;
	white) id="37" ;;
	*) abort "Invalid color: ${color}" ;;
	esac

	echo -en "\e[${id}m${text}\e[0m"
}

report() {
	if [ $# -ne 2 ] && [ $# -ne 3 ]; then
		abort "Usage: report level message [detail]"
	fi

	local level=$1
	local message=$2
	local detail=${3:-""}

	local color
	case ${level} in
	trace) color="green" ;;
	info) color="blue" ;;
	warn) color="yellow" ;;
	error) color="red" ;;
	*) abort "Invalid level: ${level}" ;;
	esac

	echo -en "\t$(print_colored "${color}" " ${message}\n")"

	if [ -n "${detail}" ] && [ "${level}" != "trace" ]; then
		echo -e "\t\t${detail}"
	fi
}

report_command_exists() {
	if [ $# -ne 2 ] && [ $# -ne 3 ]; then
		abort "Usage: report_command_exists level command [detail]"
	fi

	local level=$1
	local command=$2
	local detail=${3:-""}

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

	local level=$1
	local file_path=$2
	local detail=${3:-""}

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

	local level=$1
	local file_path=$2
	local detail=${3:-""}

	if [ ! -f "${file_path}" ]; then
		report "${level}" "File does not exist: ${file_path}" "${detail}"
	elif [ -x "${file_path}" ]; then
		report "trace" "File is executable: ${file_path}" "${detail}"
	else
		report "${level}" "File is not executable: ${file_path}" "${detail}"
	fi
}

export_functions=" \
    abort \
    print_colored \
    report \
    report_command_exists \
	report_file_readable \
	report_file_executable \
	"

export_items() {
	eval "export -f ${export_functions}"
}

unexport_items() {
	unset "${export_functions}"
}

run_checkhealth_single_config() {
	if [ $# -ne 1 ]; then
		abort "Usage: checkhealth_single_config config_dir"
	fi
	local config_dir=$1

	local checkhealth_script="${config_dir}/checkhealth.sh"
	if [ ! -e "${checkhealth_script}" ]; then
		return
	fi

	print_colored "cyan" " $(basename ${config_dir})\n"
	if [ ! -x "${checkhealth_script}" ]; then
		print_colored red "\tError: ${checkhealth_script} is not executable\n\n"
		return
	fi

	"$checkhealth_script"
	echo
}

run_checkhealth_configs() {
	DOTPATH=$(cat "$HOME/.dotpath")
	if [ -z "${DOTPATH}" ]; then
		abort "DOTPATH is not set"
	fi

	for dir in "${DOTPATH}/configs/"*; do
		run_checkhealth_single_config "${dir}"
	done
}

main() {
	export_items
	run_checkhealth_configs
	unexport_items
}

main
