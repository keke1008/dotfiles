set __fish_git_prompt_showuntrackedfiles 1
set __fish_git_prompt_show_informative_status 1
set __fish_git_prompt_showcolorhints 1

set __fish_git_prompt_char_stateseparator ''
set __fish_git_prompt_char_cleanstate ''
set __fish_git_prompt_char_dirtystate ' !'
set __fish_git_prompt_char_stagedstate ' +'
set __fish_git_prompt_char_invalidstate ' x'
set __fish_git_prompt_char_stashstate ' *'
set __fish_git_prompt_char_untrackedfiles ' ?'
set __fish_git_prompt_char_upstream_prefix ' '

set __fish_git_prompt_color_branch blue
set __fish_git_prompt_color_flags blue
set __fish_git_prompt_color_dirtystate yellow
set __fish_git_prompt_color_stagedstate yellow
set __fish_git_prompt_color_stashstate blue
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_untrackedfiles blue
set __fish_git_prompt_color_upstream yellow

set __fish_prompt_divider ''

function fish_prompt
    set -l last_status $status

    set_color blue
    printf " "(prompt_pwd --dir-length=0)
    printf " $__fish_prompt_divider"

    set vcs_status (fish_vcs_prompt "%s")
    if [ -n "$vcs_status" ]
        set_color --bold blue
        printf " "
        printf " $vcs_status"

        set_color blue
        printf " $__fish_prompt_divider"
    end

    printf "\n"
    set_color ([ "$last_status" -eq 0 ]; and echo blue; or echo red)
    printf "❯"

    printf " "
    set_color normal
end
