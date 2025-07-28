# DO NOT USE FISH AS A LOGIN SHELL.
# MY FISH CONFIGURATION IS NOT DESIGNED TO BE USED AS A LOGIN SHELL.

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

# Load fisher
set -x fisher_path "$XDG_DATA_HOME/fisher"
set -p fish_function_path "$fisher_path/functions"
set -p fish_complete_path "$fisher_path/completions"
mkdir -p "$fisher_path"
for file in $fisher_path/conf.d/*.fish
    source $file
end

if not status --is-interactive
    return
end

set -x fish_term24bit 1

function alias_if_exists
    set alias $argv[1] # 'foo=bar --baz'
    set definition (string split -m 1 '=' $alias)[2] # 'bar --baz'
    set command (string match -r '[^ ]+' $definition) # 'bar'

    if type -q $command
        alias $alias
    end
end

source $DOTFILES_CONFIG_HOME/sh/.aliases

functions -e alias_if_exists

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

complete --command aws --no-files --arguments '(_aws_complete)'

set local_config "$DOTFILES_LOCAL_HOME/fish/local_config.fish"
if [ -e $local_config ]
    source $local_config
end

# Unset the variable here to enable shell substitution, so that even if tmux is invoked again
# after the tmux session is terminated, shell substitution will be performed.
set -e DOTFILES_DISABLE_SUBSTITUTE_SHELL
