function mkcd
    if test (count $argv) -ne 1
        echo "Usage: mkcd <dir>"
        return 1
    end

    set dir $argv[1]
    mkdir -p $dir
    cd $dir
end
