function _ghq_list_repos
    if not command -q ghq || not command -q fzf
        return
    end

    if not set -l repo (ghq list | fzf --multi)
        return
    end

    set -l hoge aa bb

    commandline --insert (string join ' ' -- (ghq root)/$repo)
    commandline --function repaint
end
