# shellcheck shell=sh

abort() {
	printf "\e[31m[error] ABORTED.\e[0m $*\n"
	exit 1
}

_print_with_color_id() {
	if [ $# -ne 2 ]; then
		abort "Usage: _print_with_color_id color_id message"
	fi

	local color_id="$1"
	local message="$2"

	printf "\e[%sm" "${color_id}"
	printf "${message}"
	printf "\e[0m"
}

_map_color_id() {
	if [ $# -ne 1 ]; then
		abort "Usage: _map_color_id color"
	fi

	local color="$1"

	case ${color} in
	red) echo "31" ;;
	green) echo "32" ;;
	yellow) echo "33" ;;
	blue) echo "34" ;;
	magenta) echo "35" ;;
	cyan) echo "36" ;;
	white) echo "37" ;;

	trace) echo "32" ;;
	info) echo "34" ;;
	warn) echo "33" ;;
	error) echo "31" ;;

	*) abort "Invalid color: ${color}" ;;
	esac
}

print_colored() {
	if [ $# -ne 2 ]; then
		abort "Usage: print_colored color message"
	fi

	local color="$1"
	local message="$2"

	local color_id="$(_map_color_id "${color}")"
	_print_with_color_id "${color_id}" "${message}"
}

log() {
	if [ $# -ne 2 ]; then
		abort "Usage: log level message"
	fi

	local level="$1"
	local message="$2"

	print_colored "${level}" "[${level}]"
	printf " %s\n" "${message}"
}
