# shellcheck shell=sh

# requirements:
#  ../log.sh
#  ./declare.sh

list_placement_groups() {
    local path
    for path in "${_DOTFILES_CONFIG_HOME}"/* "${_DOTFILES_DATA_HOME}"/groups/*; do
        if [ -d "${path}" ]; then
            printf '%s\n' "$(basename "${path}")"
        fi
    done | sort -u | tr '\n' ' '
}

validate_specified_placement_groups() {
    local valid_placement_groups
    valid_placement_groups="$(list_placement_groups)"

    local invalid_placement_groups=""
    local group_name
    for group_name in "$@"; do
        case " ${valid_placement_groups} " in
        *" ${group_name} "*) ;;
        *)
            invalid_placement_groups="${invalid_placement_groups} ${group_name}"
            ;;
        esac
    done

    if [ -n "${invalid_placement_groups}" ]; then
        log 'error' "Placement group does not exist:${invalid_placement_groups}"
        return 1
    fi
}

guess_specified_placement_groups() {
    if [ "$#" -eq 0 ]; then
        list_placement_groups
        return
    fi

    if ! validate_specified_placement_groups "$@"; then
        return 1
    fi

    printf '%s ' "$@"
}

evaluate_placement_entries() {
    if [ "$#" -ne 3 ]; then
        abort 'Usage: evaluate_placement_entries <declared_placement_entries_path> <locked_placement_entries_path> <target_group_names>'
    fi

    local declared_placement_entries_path="${1}"
    local locked_placement_entries_path="${2}"
    local target_group_names="${3}"
    local handling_group_names=""

    local group_name
    for group_name in ${target_group_names}; do
        local declared_entries
        if ! declared_entries="$(list_declared_placement_entries "${group_name}")"; then
            continue
        fi

        local locked_entries
        if ! locked_entries="$(list_locked_placement_entries "${group_name}")"; then
            continue
        fi

        handling_group_names="${handling_group_names} ${group_name}"
        if [ -n "${declared_entries}" ]; then
            printf '%s\n' "${declared_entries}" >>"${declared_placement_entries_path}"
        fi
        if [ -n "${locked_entries}" ]; then
            printf '%s\n' "${locked_entries}" >>"${locked_placement_entries_path}"
        fi
    done

    printf '%s' "${handling_group_names}"
}
