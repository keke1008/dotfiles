function _popd_binding
    if test (dirs | string split ' ' | count) -le 1
        return
    end

    popd > /dev/null
    commandline -f repaint
end
