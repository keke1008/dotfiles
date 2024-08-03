if [ -n "${DOTFILES_DOT_ZPROFILE_LOADING:-}" ]; then
  return 0
fi

if [ -r "${DOTFILES_ORIGINAL_HOME}/zsh/.zprofile" ]; then
  export DOTFILES_DOT_ZPROFILE_LOADING=1
  . "${DOTFILES_ORIGINAL_HOME}/zsh/.zprofile"
  unset DOTFILES_DOT_ZPROFILE_LOADING
fi

if [ -f ~/.profile ]; then
  . "$HOME/.profile"
fi
