function fish_prompt
    set last_pipestatus $pipestatus


    set path (prompt_pwd --dir-length 3)
    if string match --quiet '/*' $path
        set prompt_path '/' (string split --no-empty '/' $path)
    else
        set prompt_path (string split '/' $path)
    end

    set prompt_git \ue725' '(fish_git_prompt '%s')

    set prompt_bg_job (jobs --command | tail -n +1 | tac)

    set prompt_status
    for st in $last_pipestatus
        if not contains $st 0 141
            set prompt_status $last_pipestatus
            break
        end
    end

    set prompt_suffix '$'
    fish_is_root_user && set prompt_suffix '#'

    echo ''
    light_prompt -f brwhite \
        -b 5a5a5a $prompt_path \
        -b 368888 $prompt_git \
        -b 888d31 $prompt_bg_job

    light_prompt -f brwhite \
        -b 881616 $prompt_status \
        -b brblack $prompt_suffix
end
