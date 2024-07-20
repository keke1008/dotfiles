#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/abort.sh"

print_export_variable_command() {
	if [ "$#" -ne 1 ]; then
		abort "Usage: print_export_variable_command <variable_name>"
	fi

	key="$1"
	value="$(eval echo "\$${key}")"
	echo "export ${key}='${value}'"
}

main() {
	variables=" \
		DOTPATH \
		XDG_CONFIG_HOME \
		DOTFILES_CONFIG_HOME \
		DOTFILES_LOCAL_HOME \
		DOTFILES_ORGINAL_HOME \
	"

	for var in $variables; do
		print_export_variable_command "$var"
	done
}

main
