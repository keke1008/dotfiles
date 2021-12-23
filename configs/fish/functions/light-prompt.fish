function __light_prompt_generate_separator_color
  set current_bg_color $argv[1]
  set next_bg_color $argv[2]
  set_color $current_bg_color -b $next_bg_color
end

function light_prompt
    set color_separator \ue0b0
    set text_separator \ue0b1
    set current_bg_color normal
    set next_bg_color normal
    set current_fg_color normal
    set next_fg_color normal
    set prompt_text ''
    set separator_char ''

    while test (count $argv) -ne 0
        switch $argv[1]
            case --foreground-color
                set next_fg_color $argv[2]
                set separator_char ''
                set argv $argv[3..-1]

            case --background-color
                set next_bg_color $argv[2]
                set separator_char ''
                test -n $prompt_text && set separator_char $color_separator
                set argv $argv[3..-1]

            case --color
                set argv --foreground-color $argv[2] --background-color $argv[3] $argv[4..-1]

            case -f
                set argv --foreground-color $argv[2..-1]

            case -b
                set argv --background-color $argv[2..-1]

            case -c
                set argv --color $argv[2..-1]

            case '-*'
                echo Unknown option: $argv[1]
                return 1

            case '*'
                if test $current_bg_color != $next_bg_color
                    set -l separator_color (__light_prompt_generate_separator_color $current_bg_color $next_bg_color)
                    set separator $separator_color$separator_char(set_color $next_fg_color -b $next_bg_color)
                else if test $current_fg_color != $next_fg_color
                    set separator $separator_char(set_color $next_fg_color -b $next_bg_color)
                else
                    set separator $text_separator
                end

                set text $argv[1]
                test -n $text && set text ' '$text' '

                set prompt_text $prompt_text$separator$text
                set current_fg_color $next_fg_color
                set current_bg_color $next_bg_color
                set argv $argv[2..-1]
        end
    end

    set tail_separator (__light_prompt_generate_separator_color $current_bg_color normal)$color_separator
    echo $prompt_text$tail_separator(set_color normal)
end
