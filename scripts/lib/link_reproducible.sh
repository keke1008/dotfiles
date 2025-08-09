# shellcheck shell=sh
#
# requirements:
#   ./log.sh

# Check whether two path exist and point to the same location.
#
# Arguments:
#    path1: The first path to compare.
#    path2: The second path to compare.
paths_point_to_same() {
	if [ "$#" -ne 2 ]; then
		log "error" "Usage: link_paths_point_to_same <path1> <path2>"
		return 1
	fi

	local path1="$1"
	local path2="$2"

	if [ ! -e "${path1}" ]; then
		return 1
	fi

	if [ ! -e "${path2}" ]; then
		return 1
	fi

	[ "$(readlink -f "${path1}")" = "$(readlink -f "${path2}")" ]
}

# Create a symlink.
# If the `link_path` already exists and points to the same target, do nothing.
# If the `link_path` already exists but points to a different target, log an error and do nothing.
# Otherwise, create the symlink.
#
# Arguments:
#    target: The target file or directory to link to.
#    link_path: The path where the symlink should be created.
link_reproducible() {
	if [ "$#" -ne 2 ]; then
		log "error" "Usage: link_reproducible <target> <link_path>"
		return 1
	fi

	local target="$1"
	local link_path="$2"

	if paths_point_to_same "${link_path}" "${target}"; then
		return
	fi

	if [ -e "${link_path}" ]; then
		log "error" "Link path ${link_path} already exists."
		return 1
	fi

	if [ ! -e "${target}" ]; then
		log "error" "Target ${target} does not exist."
		return 1
	fi

	mkdir -p "$(dirname "${link_path}")" || {
		log "error" "Failed to create directory for symlink: $(dirname "${link_path}")"
		return 1
	}

	ln -sn "${target}" "${link_path}" || {
		log "error" "Failed to create symlink: ${link_path} -> ${target}"
		return 1
	}

	log "info" "Created symlink: ${link_path} -> ${target}"
}

# Remove a symlink if it exists.
# If the `link_path` does not exist or does not point to the same target as `target`, do nothing.
# Otherwise, remove the symlink.
#
# Arguments:
#    target: The target file or directory to link to.
#    link_path: The path of the symlink to remove.
unlink_reproducible() {
	if [ "$#" -ne 2 ]; then
		log "error" "Usage: unlink_reproducible <target> <link_path>"
		return 1
	fi

	local target="$1"
	local link_path="$2"

	if ! paths_point_to_same "${link_path}" "${target}"; then
		return
	fi

	rm "${link_path}" || {
		log "error" "Failed to remove symlink ${link_path}"
		return 1
	}

	log "info" "Removed symlink: ${link_path}"
}
