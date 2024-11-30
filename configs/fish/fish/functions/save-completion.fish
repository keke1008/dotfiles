function save-completion
    set command $argv[1]
    eval $argv >$XDG_DATA_HOME/fish/vendor_completions.d/$command.fish
end
