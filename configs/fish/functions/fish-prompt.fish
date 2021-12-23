function fish_prompt
    set last_pipestatus $pipestatus

    set prompt_bg_job \uf0ae' '(jobs -cl | sed -n '1p')

    set prompt_git \ue725' '(git branch --show-current ^ /dev/null)

    set prompt_status
    string match -qvr '^(0|141)$' $last_pipestatus
    and set prompt_status (__fish_pipestatus_with_signal $last_pipestatus | string join '|')

    set prompt_suffix '$'
    contains $USER root && set prompt_suffix '#'

    echo ''
    light_prompt -f brwhite \
        -b 666666 (string replace -r "^$HOME" '~' (pwd)) \
        -b 368888 $prompt_git \
        -b 888d31 $prompt_bg_job \

    light_prompt -f brwhite \
        -b 881616 $prompt_status -b brblack $prompt_suffix
end
