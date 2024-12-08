# https://github.com/IlanCosman/tide/wiki/Configuration

function _tide_item_empty
    _tide_print_item empty '' ''
end

# prompt
set -g tide_prompt_add_newline_before false
set -g tide_prompt_color_frame_and_connection brblack
set -g tide_prompt_color_separator_same_color blue
set -g tide_prompt_icon_connection \u00b7
set -g tide_prompt_pad_items true
set -g tide_prompt_transient_enabled false

# left prompt
set -g tide_left_prompt_frame_enabled false
set -g tide_left_prompt_items pwd git jobs empty newline character
set -g tide_left_prompt_prefix
set -g tide_left_prompt_separator_diff_color \ue0b1
set -g tide_left_prompt_separator_same_color \ue0b1
set -g tide_left_prompt_suffix

# right prompt
set -g tide_right_prompt_frame_enabled false
set -g tide_right_prompt_items empty status cmd_duration
# node python rustc java php pulumi ruby go gcloud kubectl distrobox \
# toolbox terraform aws nix_shell crystal elixir zig direnv context
set -g tide_right_prompt_prefix
set -g tide_right_prompt_separator_diff_color \ue0b3
set -g tide_right_prompt_separator_same_color \ue0b3
set -g tide_right_prompt_suffix

# empty
set -g tidy_empty_bg_color
set -g tide_empty_color blue

# character
set -g tide_character_color blue
set -g tide_character_failure red
set -g tide_character_icon \u276f
set -g tide_character_vi_icon_default \u276e
set -g tide_character_vi_icon_replace \u25b6
set -g tide_character_vi_icon_visual V

# git
set -g tide_git_bg_color
set -g tide_git_bg_color_unstable
set -g tide_git_bg_color_urgent
set -g tide_git_color_branch blue
set -g tide_git_color_conflicted red
set -g tide_git_color_dirty bryellow
set -g tide_git_color_operation brred
set -g tide_git_color_staged bryellow
set -g tide_git_color_stash brgreen
set -g tide_git_color_untracked brblue
set -g tide_git_color_upstream brgreen
set -g tide_git_icon \uf418
set -g tide_git_truncation_length 24
set -g tide_git_truncation_strategy l

# jobs
set -g tide_jobs_bg_color
set -g tide_jobs_color blue
set -g tide_jobs_icon \uf013
set -g tide_jobs_number_threshold 0

# pwd
set -g tide_pwd_bg_color
set -g tide_pwd_color_anchors blue
set -g tide_pwd_color_dirs blue
set -g tide_pwd_color_truncated_dirs blue
set -g tide_pwd_icon
set -g tide_pwd_icon_home
set -g tide_pwd_icon_unwritable \uf023
set -g tide_pwd_markers .bzr .citc .git .hg .node_version .python_version .ruby_version \
    .shorten_folder_marker .svn .terraform Cargo.toml composer.json CVS go.mod package.json build.zig

# status
set -g tide_status_bg_color
set -g tide_status_bg_color_failure
set -g tide_status_color blue
set -g tide_status_color_failure red
set -g tide_status_icon \u2714
set -g tide_status_icon_failure \uea87

# context
set -g tide_context_always_display false
set -g tide_context_bg_color
set -g tide_context_color_default blue
set -g tide_context_color_root blue
set -g tide_context_color_ssh blue
set -g tide_context_hostname_parts 1

# cmd_duration
set -g tide_cmd_duration_bg_color
set -g tide_cmd_duration_color blue
set -g tide_cmd_duration_decimals 1
set -g tide_cmd_duration_icon
set -g tide_cmd_duration_threshold 3000

# direnv
set -g tide_direnv_bg_color
set -g tide_direnv_bg_color_denied
set -g tide_direnv_color blue
set -g tide_direnv_color_denied red
set -g tide_direnv_icon \u25bc

# other
set -g tide_node_bg_color
set -g tide_python_bg_color
set -g tide_rustc_bg_color
set -g tide_java_bg_color
set -g tide_php_bg_color
set -g tide_pulumi_bg_color
set -g tide_ruby_bg_color
set -g tide_go_bg_color
set -g tide_gcloud_bg_color
set -g tide_kubectl_bg_color
set -g tide_distrobox_bg_color
set -g tide_toolbox_bg_color
set -g tide_terraform_bg_color
set -g tide_aws_bg_color
set -g tide_nix_shell_bg_color
set -g tide_crystal_bg_color
set -g tide_elixir_bg_color
set -g tide_zig_bg_color

set -g tide_node_color blue
set -g tide_python_color blue
set -g tide_rustc_color blue
set -g tide_java_color blue
set -g tide_php_color blue
set -g tide_pulumi_color blue
set -g tide_ruby_color blue
set -g tide_go_color blue
set -g tide_gcloud_color blue
set -g tide_kubectl_color blue
set -g tide_distrobox_color blue
set -g tide_toolbox_color blue
set -g tide_terraform_color blue
set -g tide_aws_color blue
set -g tide_nix_shell_color blue
set -g tide_crystal_color blue
set -g tide_elixir_color blue
set -g tide_zig_color blue

set -g tide_node_icon \ue24f
set -g tide_python_icon \ue235
set -g tide_rustc_icon \ue7a8
set -g tide_java_icon \ue256
set -g tide_php_icon \ue608
set -g tide_pulumi_icon \uf1b2
set -g tide_ruby_icon \ue23e
set -g tide_go_icon \ue627
set -g tide_gcloud_icon \U000f11f6
set -g tide_kubectl_icon \U000f10fe
set -g tide_distrobox_icon \U000f01a7
set -g tide_toolbox_icon \ue24f
set -g tide_terraform_icon \U000f1062
set -g tide_aws_icon \ue7ad
set -g tide_nix_shell_icon \uf313
set -g tide_crystal_icon \ue62f
set -g tide_elixir_icon \ue62d
set -g tide_zig_icon \ue6a9
