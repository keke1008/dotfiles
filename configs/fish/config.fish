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

alias v "$EDITOR"
alias g "git"
alias c "cargo"
alias d "docker"
alias dc "docker compose"
alias kc "kubectl"
alias be "bundle exec"
alias bi "bundle install"
alias tf "terraform"
if not type -q vim
    alias vim "vi"
end
if type -q bat
    alias cat "bat"
else if type -q batcat
    alias cat "batcat"
end
if type -q trash-put
    alias rm "trash-put"
else
    alias rm "rm -i"
end

for repeat in (seq 3 10)
    set -l cd_parents_name (string repeat -n $repeat '.')
    set -l cd_parents_path (string repeat -n (math $repeat - 1) '../')

    alias $cd_parents_name "cd $cd_parents_path"
end

# colorscheme
fish_config theme choose tokyonight_night

# key bindings
if type -q fzf_key_bindings
    fzf_key_bindings
end
function ctrl_j_popd
    if test (count (string split ' ' (dirs))) -le 1
        return
    end
    popd > /dev/null
    commandline -f repaint
end
function ctrl_k_pushd
    if test $PWD = "/"
        return
    end
    pushd .. > /dev/null
    commandline -f repaint
end
bind \cj 'ctrl_j_popd'
bind \ck 'ctrl_k_pushd'

# direnv
if type -q direnv
    eval (direnv hook fish)
end



# bobthefish
set -g theme_nerd_fonts yes
set -g theme_newline_cursor yes
set -g theme_newline_prompt '$ '
set -g theme_show_exit_status yes
set -g theme_display_ruby no # This setting makes powerline fast
set -g theme_display_go no # This setting makes powerline fast

set local_config "$DOTFILES_LOCAL_HOME/fish/local_config.fish"
if [ -e $local_config ]
    source $local_config
end
