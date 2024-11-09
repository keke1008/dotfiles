# Avoid recursive loading
if set -q DOTFILES_ORIGINAL_LOADING
    return 0
end

# Bootstrapping
if not set -q DOTPATH
    if test -r "$HOME/.dotpath"
        set DOTPATH (cat "$HOME/.dotpath")
        eval ("$DOTPATH/dot" shellenv)
    else
        echo "Error: Failed to get DOTPATH" >&2
        return 1
    end
end

if status --is-login && not set -q DOTFILES_FISH_PROFILE_LOADED
    DOTFILES_FISH_PROFILE_LOADED=1 exec sh -c "source $HOME/.profile; exec fish"
end

if not status --is-interactive
    return
end

if not set -q DOTFILES_SHRC_LOADED
    DOTFILES_SHRC_LOADED=1 exec sh -c "source $HOME/.shrc; exec fish"
end

set -x fish_term24bit 1

# Fisher bootstrapping
if not type -q fisher && not set -q FISHER_BOOTSTRAPPING
    set -x FISHER_BOOTSTRAPPING true
    echo "Fisher is not installed. Installing Fisher..."

    curl -sL https://git.io/fisher | source
    fisher install \
        jorgebucaran/fisher \
        oh-my-fish/theme-bobthefish
end

function alias_if_exists
    set -q argv[3] || set argv[3] $argv[1]
    if type -q $argv[1]
        alias $argv[2] $argv[3]
    end
end

function alias_if_exists_or_else
    if type -q $argv[1]
        alias $argv[2] $argv[3]
    else
        alias $argv[2] $argv[4]
    end
end

alias l="ls"
alias v='$EDITOR'
alias g='git'
alias c='cargo'
alias d='docker'
alias dc='docker compose'
alias kc='kubectl'
alias be='bundle exec'
alias bi='bundle install'
alias tf='terraform'
alias grep='grep --color=auto'

alias_if_exists_or_else exa ls "exa" "ls --color=auto"
alias_if_exists_or_else exa ll "exa -lh" "ls -lh"
alias_if_exists_or_else exa la "exa -a" "ls -A"

alias_if_exists bat cat
alias_if_exists batcat cat
alias_if_exists_or_else trash-put rm "trash-put" "rm -i"

alias "..."="cd ../.."
alias "...."="cd ../../.."
alias "....."="cd ../../../.."

# colorscheme
fish_config theme choose tokyonight_night

function ctrl_j_popd
    test (dirs | string split ' ' | count) -le 1 && return
    popd > /dev/null
    commandline -f repaint
end
function ctrl_k_pushd
    test $PWD = "/" && return
    pushd .. > /dev/null
    commandline -f repaint
end
bind \cj 'ctrl_j_popd'
bind \ck 'ctrl_k_pushd'

if type -q direnv
    eval (direnv hook fish)
end

if type -q fzf
    fzf --fish | source
end

if type -q zoxide
    zoxide init fish | source
end

# prompt
if type -q starship
    starship init fish | source
else
    # bobthefish
    set -g theme_nerd_fonts yes
    set -g theme_newline_cursor yes
    set -g theme_newline_prompt '$ '
    set -g theme_show_exit_status yes
    set -g theme_display_ruby no # This setting makes powerline fast
    set -g theme_display_go no # This setting makes powerline fast
end

set local_config "$DOTFILES_LOCAL_HOME/fish/local_config.fish"
if [ -e $local_config ]
    source $local_config
end
