# shellcheck shell=sh

# requirements:
#  ../log.sh

_DOTFILES_PLACEMENT_ENTRY_PATH_SEPARATOR="$(printf '\037')"

build_placement_entry() {
    if [ "$#" -ne 3 ]; then
        abort "Usage: build_placement_entry <group_name> <src_path> <dst_path>"
    fi

    local group_name="${1}"
    local src_path="${2}"
    local dst_path="${3}"
    local sep="${_DOTFILES_PLACEMENT_ENTRY_PATH_SEPARATOR}"

    case "${src_path}" in
    /*)
        log error 'src_path must be a relative path'
        return 1
        ;;
    esac

    case "${dst_path}" in
    /*) ;;
    *)
        log error 'dst_path must be an absolute path'
        return 1
        ;;
    esac

    printf '%s' "${group_name}${sep}${src_path}${sep}${dst_path}${sep}"
}

placement_entry_get_group_name() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: placement_entry_get_group_name <placement_entry>'
    fi

    local sep="${_DOTFILES_PLACEMENT_ENTRY_PATH_SEPARATOR}"
    printf '%s' "${1%%"${sep}"*}"
}

placement_entry_get_src_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: placement_entry_get_src_path <placement_entry>'
    fi

    local sep="${_DOTFILES_PLACEMENT_ENTRY_PATH_SEPARATOR}"
    local prefix_removed="${1#*"${sep}"}"
    printf '%s' "${prefix_removed%%"${sep}"*}"
}

placement_entry_get_dst_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: placement_entry_get_dst_path <placement_entry>'
    fi

    local sep="${_DOTFILES_PLACEMENT_ENTRY_PATH_SEPARATOR}"
    local prefix_removed="${1#*"${sep}"*"${sep}"}"
    printf '%s' "${prefix_removed%%"${sep}"*}"
}
