# shellcheck shell=sh

DOTFILES_LOG_LEVEL="${DOTFILES_LOG_LEVEL:-info}"
_DOTFILES_EXIT_CODE=0

set_exit_code() {
	if [ $# -ne 1 ]; then
		abort "Usage: set_exit_code code"
	fi

	_DOTFILES_EXIT_CODE="$1"
}

exit_with_stored_code() {
	exit "${_DOTFILES_EXIT_CODE}"
}

abort() {
	printf "\e[31m[error] ABORTED.\e[0m %s\n" "$*"
	set_exit_code 1
	exit_with_stored_code
}

_print_with_color_id() {
	if [ $# -ne 2 ]; then
		abort "Usage: _print_with_color_id color_id message"
	fi

	local color_id="$1"
	local message="$2"

	printf "\e[%sm" "${color_id}"
	printf "%s" "${message}"
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

_map_level() {
	if [ $# -ne 1 ]; then
		abort "Usage: _map_level level"
	fi

	local level="$1"

	case ${level} in
	trace) echo "1" ;;
	info) echo "2" ;;
	warn) echo "3" ;;
	error) echo "4" ;;
	*) abort "Invalid level: ${level}" ;;
	esac
}

print_colored() {
	if [ $# -ne 2 ]; then
		abort "Usage: print_colored color message"
	fi

	local color="$1"
	local message="$2"

	_print_with_color_id "$(_map_color_id "${color}")" "${message}"
}

log() {
	if [ $# -ne 2 ]; then
		abort "Usage: log level message"
	fi

	local level="$1"
	local message="$2"

	if [ "$(_map_level "${level}")" -lt "$(_map_level "${DOTFILES_LOG_LEVEL}")" ]; then
		return
	fi

	print_colored "${level}" "[${level}]"
	printf " %s\n" "${message}"

	if [ "${level}" = "error" ] && [ "${_DOTFILES_EXIT_CODE}" -eq 0 ]; then
		_DOTFILES_EXIT_CODE=1
	fi
}
