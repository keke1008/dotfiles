if [ -f ~/.profile ]; then
  . "$HOME/.profile"
fi

if [ -f ~/.bashrc ]; then
  . "$HOME/.bashrc"
fi

local_rc="${DOTFILES_LOCAL_HOME}/bash/local_rc.sh"
if [ -f "${local_rc}" ]; then
  . "${local_rc}"
fi
