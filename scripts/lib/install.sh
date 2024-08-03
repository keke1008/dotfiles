# shellcheck shell=sh

create_original_home() {
	if [ $# -ne 1 ]; then
		abort "Usage: create_original_home <name>"
	fi

	local name="$1"

	mkdir -p "${DOTFILES_ORGINAL_HOME}/${name}"
}

is_installed() {
	if [ $# -ne 1 ]; then
		abort "Usage: is_installed <name>"
	fi

	local name="$1"

	[ -e "${DOTFILES_ORGINAL_HOME}/${name}/.installed" ]
}

mark_installed() {
	if [ $# -ne 1 ]; then
		abort "Usage: mark_installed <name>"
	fi

	local name="$1"

	touch "${DOTFILES_ORGINAL_HOME}/${name}/.installed"
}

mark_uninstalled() {
	if [ $# -ne 1 ]; then
		abort "Usage: mark_uninstalled <name>"
	fi

	local name="$1"

	if is_installed "${name}"; then
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
	if ! is_installed "${name}" && [ -e "${dst}" ]; then
		if [ -e "${DOTFILES_ORGINAL_HOME}/${name}/${stashed}" ]; then
			abort "The stashed file already exists: ${DOTFILES_ORGINAL_HOME}/${name}/${stashed}"
		fi

		# Check if the destination is already linked to the configuration file
		if [ "$(readlink -f "${dst}")" = "${DOTPATH}/configs/${name}/${src}" ]; then
			return
		fi

		mkdir -p "$(dirname "${DOTFILES_ORGINAL_HOME}/${name}/${stashed}")"
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
	if [ $# -ne 3 ] && [ $# -ne 4 ]; then
		abort "Usage: unlink_and_restore <name> <dst> <src> [stashed]"
	fi

	local name="$1"
	local dst="$2"
	local src="$3"
	local stashed="${4:-${src}}"

	# unlink
	if [ -e "${dst}" ]; then
		rm "${dst}"
	fi

	# restore
	if is_installed "${name}" && [ -e "${DOTFILES_ORGINAL_HOME}/${name}/${stashed}" ]; then
		mv "${DOTFILES_ORGINAL_HOME}/${name}/${stashed}" "${dst}"
	fi
}

# Stash the original file and create a symbolic link to the configuration file in the XDG configuration directory
#
# Arguments:
#   name: The name of the configuration directory
#   src: The path to the configuration file in the configuration directory
#       (relative path from the configuration directory)
stash_and_link_xdg_based_config() {
	if [ $# -ne 1 ] && [ $# -ne 2 ]; then
		abort "Usage: stash_and_link_xdg_config <name> [src]"
	fi

	local name="$1"
	local src="${2:-${name}}"

	stash_and_link "${name}" "${XDG_CONFIG_HOME}/${src}" "${src}"
}

# Restore the original file and uninstall the configuration file from the XDG configuration directory
#
# Arguments:
#   name: The name of the configuration directory
#   src: The path to the configuration file in the configuration directory
#       (relative path from the configuration directory)
unlink_and_restore_xdg_based_config() {
	if [ $# -ne 1 ] && [ $# -ne 2 ]; then
		abort "Usage: restore_and_unlink_xdg_config <name> [src]"
	fi

	local name="$1"
	local src="${2:-${name}}"

	unlink_and_restore "${name}" "${XDG_CONFIG_HOME}/${src}" "${src}"
}

# Stash the original file and create a symbolic link to the configuration file in the home directory
#
# Arguments:
#   name: The name of the configuration directory
#   src: The path to the configuration file in the configuration directory
#    	(relative path from the configuration directory)
stash_and_link_home_config() {
	if [ $# -ne 2 ]; then
		abort "Usage: stash_and_link_home_config <name> <src>"
	fi

	local name="$1"
	local src="$2"

	stash_and_link "${name}" "${HOME}/${src}" "${src}"
}

# Restore the original file and uninstall the configuration file from the home directory
#
# Arguments:
#   name: The name of the configuration directory
#   src: The path to the configuration file in the configuration directory
#    	(relative path from the configuration directory)
unlink_and_restore_home_config() {
	if [ $# -ne 2 ]; then
		abort "Usage: restore_and_unlink_home_config <name> <src>"
	fi

	local name="$1"
	local src="$2"

	unlink_and_restore "${name}" "${HOME}/${src}" "${src}"
}
