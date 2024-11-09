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

if status --is-interactive && not set -q DOTFILES_FISH_SHRC_LOADED
    DOTFILES_FISH_SHRC_LOADED=1 sh -c "source $HOME/.shrc"
end

# Fisher bootstrapping
set -x fisher_path "$XDG_DATA_HOME/fisher"
set -p fish_function_path "$fisher_path/functions"
set -p fish_complete_path "$fisher_path/completions"
mkdir -p "$fisher_path"
if not type -q fisher && not set -q DOTFILES_FISHER_BOOTSTRAPPING
    set -x DOTFILES_FISHER_BOOTSTRAPPING true
    echo "Fisher is not installed. Installing..."

    curl -sL https://git.io/fisher | source
    fisher update
end
for file in $fisher_path/conf.d/*.fish
    source $file
end

if not status --is-interactive
    return
end

set -x fish_term24bit 1

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

alias_if_exists_or_else exa ls exa "ls --color=auto"
alias_if_exists_or_else exa ll "exa -lh" "ls -lh"
alias_if_exists_or_else exa la "exa -a" "ls -A"

alias_if_exists bat cat
alias_if_exists batcat cat
alias_if_exists_or_else trash-put rm trash-put "rm -i"

alias "..."="cd ../.."
alias "...."="cd ../../.."
alias "....."="cd ../../../.."

# colorscheme
fish_config theme choose tokyonight_night

if type -q direnv
    eval (direnv hook fish)
end

if type -q fzf
    fzf --fish | source
end

if type -q zoxide
    zoxide init fish | source
end

fish_hybrid_key_bindings
bind \cr -M default redo # overwrite fzf keybinding
bind \cj -M default _popd_binding
bind \cj -M insert _popd_binding
bind \ck -M default _pushd_binding
bind \ck -M insert _pushd_binding

set fish_greeting

set local_config "$DOTFILES_LOCAL_HOME/fish/local_config.fish"
if [ -e $local_config ]
    source $local_config
end
