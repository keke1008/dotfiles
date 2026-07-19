#!/usr/bin/env bats

load ../../lib/log.sh
load ../../lib/placement/entry.sh

@test 'build_placement_entry returns a valid placement_entry string' {
    run build_placement_entry 'test-group' 'path/to/src' '/path/to/dst'
    [ "${status}" -eq 0 ]
    [ "${output}" = $'test-group\037path/to/src\037/path/to/dst\037' ]
}

@test 'build_placement_entry exits with non-zero status when the given src_path is not a relative path' {
    run build_placement_entry 'test-group' '/path/to/src' '/path/to/dst'
    [ "${status}" -ne 0 ]
}

@test 'build_placement_entry exits with non-zero status when the given dst_path is not an absolute path' {
    run build_placement_entry 'test-group' 'path/to/src' 'path/to/dst'
    [ "${status}" -ne 0 ]
}

@test 'placement_entry_get_group_name returns the group_name from a placement_entry' {
    run placement_entry_get_group_name $'test-group\037path/to/src\037/path/to/dst\037'
    [ "${status}" -eq 0 ]
    [ "${output}" = 'test-group' ]
}

@test 'placement_entry_get_src_path returns the src path from a placement_entry' {
    run placement_entry_get_src_path $'test-group\037path/to/src\037/path/to/dst\037'
    [ "${status}" -eq 0 ]
    [ "${output}" = 'path/to/src' ]
}

@test 'placement_entry_get_dst_path returns the dst path from a placement_entry' {
    run placement_entry_get_dst_path $'test-group\037path/to/src\037/path/to/dst\037'
    [ "${status}" -eq 0 ]
    [ "${output}" = '/path/to/dst' ]
}
