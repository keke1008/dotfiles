if [ -r "$DOTPATH/configs/sh/common_rc.sh" ]; then
    . "$DOTPATH/configs/sh/common_rc.sh"
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

bindkey -e
bindkey "^[[1;5D" backward-word # ctrl + left
bindkey "^[[1;5C" forward-word # ctrl + right
bindkey "^[[H" beginning-of-line # HOME
bindkey "^[[1~" beginning-of-line # HOME
bindkey "^[[F" end-of-line # END
bindkey "^[[4~" end-of-line # END
bindkey "^[[3~" delete-char # DELETE
bindkey "^[[1;5A" history-beginning-search-backward # ctrl + up
bindkey "^[[1;5B" history-beginning-search-forward # ctrl + down
ctrl_j_popd() {
    if [ "$(dirs -v | wc -l)" -le 1 ]; then
        return
    fi
    popd >>/dev/null
    zle reset-prompt
}
ctrl_k_pushd() {
    if [ "$PWD" = "/" ]; then
        return
    fi
    pushd .. >>/dev/null
    zle reset-prompt
}
zle -N ctrl_j_popd
zle -N ctrl_k_pushd
bindkey "^J" ctrl_j_popd
bindkey "^K" ctrl_k_pushd

# direnv
if command -v "direnv" >/dev/null; then
    eval "$(direnv hook zsh)"
fi

zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

create_prompt() {
    local last_status="$?"

    local first_line=""

    # last status
    if [ "${last_status}" -ne 0 ]; then
        first_line="%F{red}%B%?%b%f "
    fi

    # user@host
    local first_line="${first_line}%F{blue}%m@%n%f "

    # current directory
    local first_line="${first_line}%F{blue}%B%~%b%f "

    # git branch
    local git_branch
    if git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"; then
        first_line="${first_line}%F{cyan}(${git_branch})%f "
    fi

    local second_line=""

    # prompt symbol
    second_line="${second_line}%F{cyan}%B%#%b%f "

    PROMPT="${first_line}"$'\n'"${second_line}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd create_prompt

local_rc="${DOTFILES_LOCAL_HOME}/zsh/local_rc.sh"
if [ -r "${local_rc}" ]; then
    . "${local_rc}"
fi
