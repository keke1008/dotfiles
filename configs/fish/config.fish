# run tmux if it is not running
if type tmux > /dev/null 2>&1
  if [ -z "$TMUX" ]
    tmux
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

set -x DOTPATH (cat "$HOME/.dotpath")

# if running in WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]
  set -x PATH "$DOTPATH/bin/wsl" $PATH
  set -x BROWSER "firefox"
  set -x DISPLAY (hostname)".mshome.net:0.0"
end

set -x RUST_BACKTRACE 1

alias v nvim