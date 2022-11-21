set -x DOTPATH (cat "$HOME/.dotpath")
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x fish_term24bit 1

# run tmux if it is not running
if type tmux > /dev/null 2>&1
  if [ -z "$TMUX" ]
    tmux -2
  end
end

# Fisher bootstrapping
if not type -q fisher && not set -q FISHER_BOOTSTRAPPING
    set -x FISHER_BOOTSTRAPPING true
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
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

# fzf key bind
if type fzf_key_bindings > /dev/null 2>&1
    fzf_key_bindings
end

# if running on WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]
  set -x PATH "$DOTPATH/bin/wsl" $PATH
  set -x BROWSER "firefox"
  set -x DISPLAY (hostname)".mshome.net:0.0"
end

set -x RUST_BACKTRACE 1

if type nvim > /dev/null 2>&1
    set -x EDITOR nvim
end

alias v nvim

for repeat in (seq 3 10)
    set cd_parents_name (string repeat -n $repeat '.')
    set cd_parents_path (string repeat -n (math $repeat - 1) '../')

    alias $cd_parents_name "cd $cd_parents_path"
end

set -e cd_parents_name
set -e cd_parents_path

# colorscheme
tokyonight_night

# bobthefish
set -g theme_nerd_fonts yes
set -g theme_newline_cursor yes
set -g theme_newline_prompt '$ '
set -g theme_show_exit_status yes
