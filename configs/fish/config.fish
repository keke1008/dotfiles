# run tmux if it is not running
if type tmux > /dev/null 2>&1
  if [ -z "$TMUX" ]
    tmux -2
  end
end

# user's private bin
if [ -d "$HOME/.local/bin" ]
    set -x PATH "$HOME/.local/bin" $PATH
end

# cargo
if [ -d "$HOME/.cargo/bin" ]
    set -x PATH "$HOME/.cargo/bin" $PATH
end

# deno
if [ -d "$HOME/.deno/bin" ]
    set -x PATH "$HOME/.deno/bin" $PATH
end

# ghcup
if [ -e "$HOME/.ghcup/env" ]
    set -x PATH (sh -c '. $HOME/.ghcup/env && echo $PATH')
end

# asdf
if [ -e "$HOME/.asdf/asdf.fish" ]
    source "$HOME/.asdf/asdf.fish"
end

# fzf key bind
if type fzf_key_bindings > /dev/null 2>&1
    fzf_key_bindings
end

set -x DOTPATH (cat "$HOME/.dotpath")

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
    set cd_parents_path (string repeat -n $repeat '../')

    alias $cd_parents_name "cd $cd_parents_path"
end

set -e cd_parents_name
set -e cd_parents_path
