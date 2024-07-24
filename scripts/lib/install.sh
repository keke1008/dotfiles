# shellcheck shell=sh

create_original_home() {
	if [ $# -ne 1 ]; then
		abort "Usage: create_original_home <name>"
	fi

	local name="$1"

	mkdir -p "${DOTFILES_ORGINAL_HOME}/${name}"
}

is_stashed() {
	if [ $# -ne 1 ]; then
		abort "Usage: is_stashed <name>"
	fi

	local name="$1"

	[ -e "${DOTFILES_ORGINAL_HOME}/${name}/.stashed" ]
}

mark_stashed() {
	if [ $# -ne 1 ]; then
		abort "Usage: mark_stashed <name>"
	fi

	local name="$1"

	touch "${DOTFILES_ORGINAL_HOME}/${name}/.stashed"
}

mark_unstashed() {
	if [ $# -ne 1 ]; then
		abort "Usage: mark_unstashed <name>"
	fi

	local name="$1"

	if is_stashed "${name}"; then
		rm "${DOTFILES_ORGINAL_HOME}/${name}/.stashed"
	fi
}

# Stash the original file and link the configuration file
#
# Arguments:
#  name: The name of the configuration directory
#   dst: The path to place the configuration file (absolute path)
#   src: The path to the configuration file in the configuration directory
#  		(relative path from the configuration directory)
#  	stashed: The path to the stashed file in the original home directory
#  		(relative path from the original configuration directory)
stash_and_link() {
	if [ $# -ne 3 ] && [ $# -ne 4 ]; then
		abort "Usage: stash_and_link <name> <dst> <src> [stashed]"
	fi

	local name="$1"
	local dst="$2"
	local src="$3"
	local stashed="${4:-${src}}"

	# stash
	if ! is_stashed "${name}" && [ -e "${dst}" ]; then
		if [ -e "${DOTFILES_ORGINAL_HOME}/${name}/${stashed}" ]; then
			abort "The stashed file already exists: ${DOTFILES_ORGINAL_HOME}/${name}/${stashed}"
		fi

		mv "${dst}" "${DOTFILES_ORGINAL_HOME}/${name}/${stashed}"
	fi

	# link
	ln -snfv "${DOTPATH}/configs/${name}/${src}" "${dst}"
}

# Unlink the configuration file and restore the original file
#
# Arguments:
#   name: The name of the configuration directory
#   dst: The path to place the configuration file (absolute path)
#  	stashed: The path to the stashed file in the original home directory
#  		(relative path from the original configuration directory)
unlink_and_restore() {
	if [ $# -ne 3 ]; then
		abort "Usage: unlink_and_restore <name> <dst> <src> [stashed]"
	fi

	local name="$1"
	local dst="$2"
	local stashed="${3}"

	# unlink
	if [ -e "${dst}" ]; then
		rm "${dst}"
	fi

	# restore
	if is_stashed "${name}" && [ -e "${DOTFILES_ORGINAL_HOME}/${name}/${stashed}" ]; then
		mv "${DOTFILES_ORGINAL_HOME}/${name}/${stashed}" "${dst}"
	fi
}

# Install the configuration file to the XDG_CONFIG_HOME
#
# Arguments:
#   name: The name of the configuration directory
#   src: The path to the configuration file in the configuration directory
#       (relative path from the configuration directory)
install_xdg_based_config() {
	if [ $# -ne 1 ] && [ $# -ne 2 ]; then
		abort "Usage: install_xdg_config <name> [src]"
	fi

	local name="$1"
	local src="${2:-${name}}"

	create_original_home "${name}"
	stash_and_link "${name}" "${XDG_CONFIG_HOME}/${src}" "${src}"
	mark_stashed "${name}"
}

# Restore the original file and uninstall the configuration file from the XDG_CONFIG_HOME
#
# Arguments:
#   name: The name of the configuration directory
#   src: The path to the configuration file in the configuration directory
#       (relative path from the configuration directory)
restore_xdg_based_config() {
	if [ $# -ne 1 ] && [ $# -ne 2 ]; then
		abort "Usage: restore_xdg_config <name> [src]"
	fi

	local name="$1"
	local src="${2:-${name}}"

	unlink_and_restore "${name}" "${XDG_CONFIG_HOME}/${src}" "${src}"
	mark_unstashed "${name}"
}

# Install the configuration file to the home directory
#
# Arguments:
#   name: The name of the configuration directory
#   src: The path to the configuration file in the configuration directory
#    	(relative path from the configuration directory)
install_home_config() {
	if [ $# -lt 2 ]; then
		abort "Usage: install_home_config <name> <src>..."
	fi

	local name="$1"
	shift

	create_original_home "${name}"
	for src in "$@"; do
		stash_and_link "${name}" "${HOME}/${src}" "${src}"
	done
	mark_stashed "${name}"
}

# Restore the original file and uninstall the configuration file from the home directory
#
# Arguments:
#   name: The name of the configuration directory
#   src: The path to the configuration file in the configuration directory
#    	(relative path from the configuration directory)
restore_home_config() {
	if [ $# -lt 2 ]; then
		abort "Usage: restore_home_config <name> <src>..."
	fi

	local name="$1"
	shift

	for src in "$@"; do
		unlink_and_restore "${name}" "${HOME}/${src}" "${src}"
	done
	mark_unstashed "${name}"
}
