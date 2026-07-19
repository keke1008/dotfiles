#!/usr/bin/env bats

load ../../lib/log.sh
load ../../lib/placement/entry.sh
load ../../lib/placement/group.sh

@test 'resolve_absolute_src_path returns an absolute path to src path' {
    export _DOTFILES_CONFIG_HOME='/path/to/dotfiles-src-root'
    local placement_entry
    placement_entry="$(build_placement_entry 'test-group' 'path/to/src' '/path/to/dst')"
    run resolve_absolute_src_path "${placement_entry}"
    [ "${status}" -eq 0 ]
    [ "${output}" = '/path/to/dotfiles-src-root/test-group/path/to/src' ]
}

@test 'resolve_absolute_dst_path returns an absolute path to dst path' {
    local placement_entry
    placement_entry="$(build_placement_entry 'test-group' 'path/to/src' '/path/to/dst')"
    run resolve_absolute_dst_path "${placement_entry}"
    [ "${status}" -eq 0 ]
    [ "${output}" = '/path/to/dst' ]
}

@test 'resolve_absolute_stash_path returns an absolute path to stash path' {
    export _DOTFILES_STASH_ROOT='/path/to/dotfiles-stash-root'
    local placement_entry
    placement_entry="$(build_placement_entry 'test-group' 'path/to/src' '/path/to/dst')"
    run resolve_absolute_stash_path "${placement_entry}"
    [ "${status}" -eq 0 ]
    [ "${output}" = '/path/to/dotfiles-stash-root/test-group/path/to/src' ]
}

@test 'resolve_placement_entries_declaration_script_path returns a path to install.sh' {
    export _DOTFILES_CONFIG_HOME='/path/to/dotfiles-config-home'
    run resolve_placement_entries_declaration_script_path 'test-group'
    [ "${status}" -eq 0 ]
    [ "${output}" = '/path/to/dotfiles-config-home/test-group/install.sh' ]
}

@test 'resolve_placement_entries_lockfile_path returns a path to placement_entries.lock' {
    export _DOTFILES_DATA_HOME='/path/to/dotfiles-data-home'
    run resolve_placement_entries_lockfile_path 'test-group'
    [ "${status}" -eq 0 ]
    [ "${output}" = '/path/to/dotfiles-data-home/groups/test-group/placement_entries.lock' ]
}
