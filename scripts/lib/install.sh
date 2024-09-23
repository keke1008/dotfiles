# shellcheck shell=sh
#
# requirements:
#  ./log.sh

create_original_home() {
	if [ $# -ne 1 ]; then
		abort "Usage: create_original_home <name>"
	fi

	local name="$1"

	mkdir -p "${DOTFILES_ORIGINAL_HOME}/${name}"
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
	local src="${DOTPATH}/configs/${name}/${3}"
	local stashed="${DOTFILES_ORIGINAL_HOME}/${name}/${4:-${3}}"

	# Do nothing if the destination is already linked to the configuration file
	if [ -e "${dst}" ] && [ "$(readlink -f "${dst}")" = "${src}" ]; then
		return
	fi

	# Check if the stashed file already exists
	if [ -e "${stashed}" ]; then
		log "error" "The stashed file already exists: ${stashed}"
		return
	fi

	# stash
	if [ -e "${dst}" ]; then
		log "info" "Stashing ${dst} to ${stashed}"
		mkdir -p "$(dirname "${stashed}")"
		mv "${dst}" "${stashed}"
	fi

	# link
	log "info" "Linking ${src} to ${dst}"
	ln -snf "${src}" "${dst}"
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
	local src="${DOTPATH}/configs/${name}/${3}"
	local stashed="${DOTFILES_ORIGINAL_HOME}/${name}/${4:-${3}}"

	# Do nothing if the destination is not linked to the configuration file
	if [ ! -e "${dst}" ] || [ "$(readlink -f "${dst}")" != "${src}" ]; then
		return
	fi

	# unlink
	log "info" "Unlinking ${dst}"
	rm "${dst}"

	# restore
	if [ -e "${stashed}" ]; then
		log "info" "Restoring ${stashed} to ${dst}"
		mv "${stashed}" "${dst}"
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
