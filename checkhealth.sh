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

	local left_escape="\\e["
	local right_escape="\\e[0m"

	local id
	case ${color} in
	red) id="31" ;;
	green) id="32" ;;
	yellow) id="33" ;;
	blue) id="34" ;;
	*) abort "Invalid color: ${color}" ;;
	esac

	echo -en "${left_escape}${id}m${text}${right_escape}"
}

report() {
	if [ $# -ne 2 ] && [ $# -ne 3 ]; then
		abort "Usage: report level message [detail]"
	fi

	local level=$1
	local message=$2
	local detail=${3:-""}

	local text=" ${message}\n"

	local color
	case ${level} in
	trace) color="green" ;;
	info) color="blue" ;;
	warn) color="yellow" ;;
	error)
		color="red"
		echo "E" >&2
		;;
	*) abort "Invalid level: ${level}" ;;
	esac

	echo -en "\t$(print_colored "${color}" "${text}")"

	if [ -n "${detail}" ]; then
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

export_functions=" \
    abort \
    print_colored \
    report \
    report_command_exists"

export_items() {
	eval "export -f ${export_functions}"
}

unexport_items() {
	unset "${export_functions}"
}

run_checkhealth_single_config() {
	# 0: success
	# 1: error
	# 2: ignore

	if [ $# -ne 1 ]; then
		abort "Usage: checkhealth_single_config config_dir"
	fi

	local config_dir=$1
	local checkhealth_script="${config_dir}/checkhealth.sh"
	if [ ! -x "${checkhealth_script}" ]; then
		if [ -e "${checkhealth_script}" ]; then
			print_colored red "\tError: ${checkhealth_script} is not executable\n\n"
			return 1
		else
			return 2
		fi

	fi

	local temp_stderr
	temp_stderr=$(mktemp)
	# shellcheck disable=SC2064
	trap "rm -f ${temp_stderr}" EXIT

	if ! "${checkhealth_script}" 2>"${temp_stderr}"; then
		print_colored red "\tError: ${checkhealth_script} exited with non-zero status\n"
		print_colored red "\tstderr:\n"
		cat "${temp_stderr}"
		echo
		return 1
	fi

	test ! -s "${temp_stderr}"
	return $?
}

checkhealth_single_config() {
	if [ $# -ne 1 ]; then
		abort "Usage: checkhealth_single_config config_dir"
	fi

	local config_dir=$1

	local title
	title=" $(basename "${config_dir}")"

	local stdout
	stdout=$(run_checkhealth_single_config "${config_dir}")
	case $? in
	0)
		print_colored green "${title}\n"
		local result=0
		;;
	1)
		print_colored red "${title}\n"
		local result=1
		;;
	2)
		return 0
		;;
	*)
		abort "Invalid return code"
		;;
	esac

	echo -e "${stdout}"
	return ${result}
}

checkhealth_configs() {
	DOTPATH=$(cat "$HOME/.dotpath")
	if [ -z "${DOTPATH}" ]; then
		abort "DOTPATH is not set"
	fi

	local is_all_health=0
	for dir in "${DOTPATH}/configs/"*; do
		if ! checkhealth_single_config "${dir}"; then
			is_all_health=1
		fi
	done

	return ${is_all_health}
}

main() {
	export_items
	if ! checkhealth_configs; then
		print_colored red "Some configurations are unhealthy\n"
		local result=1
	else
		print_colored green "All configurations are healthy\n"
		local result=0
	fi

	unexport_items
	exit ${result}
}

main
