# shellcheck shell=sh

# requirements:
#  ../log.sh
#  ./entry.sh

resolve_absolute_src_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: resolve_absolute_src_path <placement_entry>'
    fi

    local group_name src_path
    group_name="$(placement_entry_get_group_name "${1}")"
    src_path="$(placement_entry_get_src_path "${1}")"

    printf '%s' "${_DOTFILES_CONFIG_HOME}/${group_name}/${src_path}"
}

resolve_absolute_dst_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: resolve_absolute_dst_path <placement_entry>'
    fi

    local dst_path
    dst_path="$(placement_entry_get_dst_path "${1}")"

    printf '%s' "${dst_path}" # dst_path must be an absolute path
}

resolve_absolute_stash_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: resolve_absolute_stash_path <placement_entry>'
    fi

    local group_name src_path
    group_name="$(placement_entry_get_group_name "${1}")"
    src_path="$(placement_entry_get_src_path "${1}")"

    printf '%s' "${_DOTFILES_STASH_ROOT}/${group_name}/${src_path}"
}

resolve_initialize_script_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: resolve_initialize_script_path <group_name>'
    fi

    printf '%s' "${_DOTFILES_CONFIG_HOME}/${group_name}/init.sh"
}

resolve_checkhealth_script_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: resolve_checkhealth_script_path <group_name>'
    fi

    printf '%s' "${_DOTFILES_CONFIG_HOME}/${group_name}/checkhealth.sh"
}

resolve_placement_entries_declaration_script_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: resolve_placement_entries_declaration_script_path <group_name>'
    fi

    printf '%s' "${_DOTFILES_CONFIG_HOME}/${1}/install.sh"
}

resolve_placement_entries_lockfile_path() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: resolve_placement_entries_lockfile_path <group_name>'
    fi

    printf '%s' "${_DOTFILES_DATA_HOME}/groups/${1}/placement_entries.lock"
}

list_locked_placement_entries() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: list_locked_placement_entries <group_name>'
    fi

    local lockfile_path
    lockfile_path="$(resolve_placement_entries_lockfile_path "$1")"

    if ! [ -r "${lockfile_path}" ]; then
        return
    fi

    cat "${lockfile_path}"
}

lock_placement_entries() {
    if [ "$#" -ne 2 ]; then
        abort 'Usage: lock_placement_entries <group_name> <placement_entries>'
    fi

    local lockfile_path
    lockfile_path="$(resolve_placement_entries_lockfile_path "${1}")"
    log 'trace' "Locking placement_group: ${lockfile_path}"

    mkdir -p "$(dirname "${lockfile_path}")"
    if ! printf '%s\n' "${2}" >"${lockfile_path}"; then
        log 'error' "Failed to write to lockfile: ${lockfile_path}"
        return 1
    fi
}

unlock_placement_entries() {
    if [ "$#" -ne 1 ]; then
        abort 'Usage: unlock_placement_entries <group_name>'
    fi

    local lockfile_path
    lockfile_path="$(resolve_placement_entries_lockfile_path "${1}")"
    log 'trace' "Unlocking placement_group: ${lockfile_path}"

    if [ -f "${lockfile_path}" ]; then
        rm "${lockfile_path}"
    fi
}
