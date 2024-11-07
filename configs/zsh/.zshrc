if [ -n "${DOTFILES_ORIGINAL_LOADING:-}" ]; then
    return 0
fi

# Avoid recursive loading
if [ -r "${DOTFILES_ORIGINAL_HOME}/zsh/.zshrc" ]; then
    DOTFILES_ORIGINAL_LOADING=1 . "${DOTFILES_ORIGINAL_HOME}/zsh/.zshrc"
fi

if [ -r "${HOME}/.shrc" ]; then
    DOTFILES_DISABLE_SUBSTITUTE_SHELL=1 . "${HOME}/.shrc"
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
    [ "$(dirs -v | wc -l)" -le 1 ] && return
    popd >>/dev/null
    zle reset-prompt
}
ctrl_k_pushd() {
    [ "$PWD" = "/" ] && return
    pushd .. >>/dev/null
    zle reset-prompt
}
zle -N ctrl_j_popd
zle -N ctrl_k_pushd
bindkey "^J" ctrl_j_popd
bindkey "^K" ctrl_k_pushd

autoload -U select-word-style
select-word-style bash

if [ ! -d "${XDG_DATA_HOME}/.antidote" ] && command -v "git" >/dev/null; then
    git clone https://github.com/mattmc3/antidote "${XDG_DATA_HOME}/.antidote"
fi
if [ -d "${XDG_DATA_HOME}/.antidote" ]; then
    source "${XDG_DATA_HOME}/.antidote/antidote.zsh"
    antidote load
else
    function zsh-defer() {
        if [ "$1" = "-c" ]; then
            shift
            eval "$@"
        else
            "$@"
        fi
    }
fi

# direnv
if command -v "direnv" >/dev/null; then
    zsh-defer -c 'eval "$(direnv hook zsh)"'
fi

if command -v "fzf" >/dev/null; then
    zsh-defer -c 'source <(fzf --zsh)'
fi

zstyle ':completion:*' menu yes select
autoload -Uz compinit
compinit

if command -v "starship" >/dev/null; then
    eval "$(starship init zsh)"
else
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
fi

local_rc="${DOTFILES_LOCAL_HOME}/zsh/local_rc.sh"
if [ -r "${local_rc}" ]; then
    . "${local_rc}"
fi
