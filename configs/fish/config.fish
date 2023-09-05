set -x DOTPATH (cat "$HOME/.dotpath")
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x fish_term24bit 1

# Execute tmux if it is not running
if type -q tmux && [ -z "$TMUX" ]
    tmux
end

# Fisher bootstrapping
if not type -q fisher && not set -q FISHER_BOOTSTRAPPING
    set -x FISHER_BOOTSTRAPPING true
    curl -sL https://git.io/fisher | source

    fisher install \
        jorgebucaran/fisher \
        oh-my-fish/theme-bobthefish \
        jethrokuan/z \
        0rax/fish-bd
end

# user's private bin
if [ -d "$HOME/.local/bin" ]
    fish_add_path "$HOME/.local/bin"
end

# cargo
if [ -d "$HOME/.cargo/bin" ]
    fish_add_path "$HOME/.cargo/bin"
end

# deno
if [ -d "$HOME/.deno/bin" ]
    fish_add_path "$HOME/.deno/bin"
end

# ghcup
if [ -e "$HOME/.ghcup/env" ]
    set -x PATH (sh -c '. $HOME/.ghcup/env && echo $PATH')
end

# asdf
if [ -e "$HOME/.asdf/asdf.fish" ]
    source "$HOME/.asdf/asdf.fish"
end

# luarocks
if [ -d "$HOME/.luarocks/bin" ]
    fish_add_path "$HOME/.luarocks/bin"
end

# snap
if [ -d "/snap/bin" ]
    fish_add_path "/snap/bin"
end

# fly.io
if [ -d "$HOME/.fly" ]
    fish_add_path "$HOME/.fly/bin"
end

if [ -d "$HOME/.platformio/penv/bin" ]
    fish_add_path "$HOME/.platformio/penv/bin"
end

# fzf key bind
if type -q fzf_key_bindings
    fzf_key_bindings
end

# if running on WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]
    fish_add_path "$DOTPATH/bin/wsl"

    # if WSL has WSLg
    if type -q "wslg.exe"
        set -x DISPLAY ":0"
    else
        set -x DISPLAY (hostname)".mshome.net:0.0"
    end
end

if type -q nvim
    set -x EDITOR nvim
end


# aliases
alias g git
alias v nvim
alias c cargo
alias d docker
alias dc "docker compose"
alias be "bundle exec"
alias bi "bundle install"

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
