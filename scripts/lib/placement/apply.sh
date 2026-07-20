# shellcheck shell=sh

# requirements:
#  ../log.sh
#  ./group.sh

_placement_paths_point_to_same() {
    if [ "$#" -ne 2 ]; then
        abort 'Usage: _placement_paths_point_to_same <path1> <path2>'
    fi

    if [ ! -e "${1}" ]; then
        return 1
    fi

    if [ ! -e "${2}" ]; then
        return 1
    fi

    [ "$(realpath "${1}")" = "$(realpath "${2}")" ]
}

apply_placement_entry() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: apply_placement_entry <placement_entry>'
    fi

    local placement_entry="${1}"
    local src_path dst_path stash_path
    src_path="$(resolve_absolute_src_path "${placement_entry}")"
    dst_path="$(resolve_absolute_dst_path "${placement_entry}")"
    stash_path="$(resolve_absolute_stash_path "${placement_entry}")"

    if _placement_paths_point_to_same "${src_path}" "${dst_path}"; then
        return # already linked, so do nothing.
    fi

    if ! [ -e "${src_path}" ]; then
        log 'error' "The source config file does not exist: ${src_path}"
        return 1
    fi

    if [ -e "${stash_path}" ]; then
        log 'error' "The stashed file already exists: ${stash_path}"
        return 1
    fi

    if [ -e "${dst_path}" ]; then
        log 'info' "Stashing ${dst_path} to ${stash_path}"
        mkdir -p "$(dirname "${stash_path}")"
        mv "${dst_path}" "${stash_path}"
    fi

    mkdir -p "$(dirname "${dst_path}")"
    if ! ln -sn "${src_path}" "${dst_path}"; then
        log 'error' "Failed to create symlink: ${dst_path} -> ${src_path}"
        return 1
    fi

    log 'info' "Created symlink: ${dst_path} -> ${src_path}"
}

unapply_placement_entry() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: unapply_placement_entry <placement_entry>'
    fi

    local placement_entry="${1}"
    local src_path dst_path stash_path
    src_path="$(resolve_absolute_src_path "${placement_entry}")"
    dst_path="$(resolve_absolute_dst_path "${placement_entry}")"
    stash_path="$(resolve_absolute_stash_path "${placement_entry}")"

    if ! _placement_paths_point_to_same "${src_path}" "${dst_path}"; then
        return # The placement_entry has not been applied yet, so do nothing.
    fi

    if ! rm "${dst_path}"; then
        log 'error' "Failed to remove symlink ${dst_path}"
        return 1
    fi

    log 'info' "Removed symlink: ${dst_path}"

    if [ -e "${stash_path}" ]; then
        log 'info' "Restoring ${stash_path} to ${dst_path}"
        mv "${stash_path}" "${dst_path}"
    fi
}
