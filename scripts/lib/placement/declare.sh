# shellcheck shell=sh

# requirements:
#  ../log.sh
#  ./entry.sh
#  ./group.sh

declare_config_link() {
    if [ "$#" -ne 2 ]; then
        abort 'Usage: declare_config_link <src_path> <dst_path>'
    fi

    local group_name="${_DOTFILES_DECLARE_PLACEMENT_GROUP_NAME}"
    local src_path="${1}"
    local dst_path="${2}"
    local entry
    entry="$(build_placement_entry "${group_name}" "${src_path}" "${dst_path}")"
    printf '%s\n' "${entry}"
}

declare_home_config_link() {
    if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
        abort 'Usage: declare_home_config_link <src_path> [dst_path]'
    fi

    local group_name="${_DOTFILES_DECLARE_PLACEMENT_GROUP_NAME}"
    local src_path="${1}"
    local dst_path="${HOME}/${2:-"${src_path}"}"
    local entry
    entry="$(build_placement_entry "${group_name}" "${src_path}" "${dst_path}")"
    printf '%s\n' "${entry}"
}

declare_xdg_config_link() {
    if [ "$#" -gt 2 ]; then
        abort 'Usage: declare_xdg_config_link [src_path] [dst_path]'
    fi

    local group_name="${_DOTFILES_DECLARE_PLACEMENT_GROUP_NAME}"
    local src_path="${1:-${group_name}}"
    local dst_path="${XDG_CONFIG_HOME}/${2:-"${src_path}"}"
    local entry
    entry="$(build_placement_entry "${group_name}" "${src_path}" "${dst_path}")"
    printf '%s\n' "${entry}"
}

declare_local_bin_link() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: declare_local_bin_link <src_path>'
    fi

    local group_name="${_DOTFILES_DECLARE_PLACEMENT_GROUP_NAME}"
    local src_path="${1}"
    local dst_path
    dst_path="${HOME}/.local/bin/$(basename "${src_path}")"
    local entry
    entry="$(build_placement_entry "${group_name}" "${src_path}" "${dst_path}")"
    printf '%s\n' "${entry}"
}

declare_local_bin_dir_link() {
    if [ "$#" -ne 0 ] && [ "$#" -ne 1 ]; then
        abort 'Usage: declare_local_bin_dir_link [src_dir_path]'
    fi

    local group_name="${_DOTFILES_DECLARE_PLACEMENT_GROUP_NAME}"
    local src_dir_path="${1:-bin}"

    local bin_dir_entry absolute_src_dir_path
    bin_dir_entry="$(build_placement_entry "${group_name}" "${src_dir_path}" "/")"
    absolute_src_dir_path="$(resolve_absolute_src_path "${bin_dir_entry}")"

    if [ ! -d "${absolute_src_dir_path}" ]; then
        log 'error' "The source directory does not exist: ${absolute_src_dir_path}"
        return 1
    fi

    local src_path
    for src_path in "${absolute_src_dir_path}"/*; do
        if [ -e "${src_path}" ]; then
            declare_local_bin_link "${src_dir_path}/$(basename "${src_path}")"
        fi
    done
}

list_declared_placement_entries() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: list_declared_placement_entries <group_name>'
    fi

    local group_name="${1}"

    local declaration_script_path
    declaration_script_path="$(resolve_placement_entries_declaration_script_path "${1}")"

    if ! [ -e "${declaration_script_path}" ]; then
        return
    fi

    export _DOTFILES_DECLARE_PLACEMENT_GROUP_NAME="${group_name}"
    local declared_entries
    # shellcheck disable=SC1090
    if ! declared_entries="$(. "${declaration_script_path}")"; then
        unset _DOTFILES_DECLARE_PLACEMENT_GROUP_NAME
        log 'error' "Failed to evaluate declaration script: ${declaration_script_path}"
        return 1
    fi
    unset _DOTFILES_DECLARE_PLACEMENT_GROUP_NAME

    printf '%s' "${declared_entries}"
}
