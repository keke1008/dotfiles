#!/bin/sh -eu

. "${_DOTFILES_SCRIPT_HOME}/lib/log.sh"

print_export_variable_command() {
	if [ "$#" -ne 1 ]; then
		abort "Usage: print_export_variable_command <variable_name>"
	fi

	local key="$1"
	local value
	value="$(eval echo "\$${key}")"
	echo "export ${key}='${value}'"
}

main() {
	local variables=" \
		DOTPATH \
		XDG_CONFIG_HOME \
		XDG_DATA_HOME \
		DOTFILES_CONFIG_HOME \
		DOTFILES_DATA_HOME \
		DOTFILES_LOCAL_HOME \
		DOTFILES_ORIGINAL_HOME \
	"

	for var in $variables; do
		print_export_variable_command "$var"
	done

	exit_with_stored_code
}

main
