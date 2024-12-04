function save-completion
    set command $argv[1]

    set completions_dir $XDG_DATA_HOME/fish/vendor_completions.d
    mkdir -p $completions_dir

    eval $argv >$completions_dir/$command.fish
end
