function _pushd_binding
    if test $PWD = /
        return
    end

    pushd .. >/dev/null
    commandline -f repaint
end
