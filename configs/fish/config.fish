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

if type -q fzf_key_bindings
    fzf_key_bindings
end

alias v "$EDITOR"
alias g "git"
alias c "cargo"
alias d "docker"
alias dc "docker compose"
alias kc "kubectl"
alias be "bundle exec"
alias bi "bundle install"
if not type -q vim
    alias vim "vi"
end
if type -q bat
    alias cat "bat"
end

for repeat in (seq 3 10)
    set -l cd_parents_name (string repeat -n $repeat '.')
    set -l cd_parents_path (string repeat -n (math $repeat - 1) '../')

    alias $cd_parents_name "cd $cd_parents_path"
end

# colorscheme
tokyonight_night

# bobthefish
set -g theme_nerd_fonts yes
set -g theme_newline_cursor yes
set -g theme_newline_prompt '$ '
set -g theme_show_exit_status yes
set -g theme_display_ruby no # This setting makes powerline fast
set -g theme_display_go no # This setting makes powerline fast

set local_config "$DOTPATH/configs/fish/local.fish"
if [ -e $local_config ]
    source $local_config
end
