if [ -n "${DOTFILES_DOT_ZPROFILE_LOADING:-}" ]; then
  return 0
fi

# Bootstrapping
if [ -r "$HOME/.dotpath" ] && DOTPATH=$(cat "$HOME/.dotpath"); then
	eval "$("${DOTPATH}/dot" shellenv)"
else
	echo "Error: Failed to get DOTPATH" >&2
	return 1
fi

if [ -r "${DOTFILES_ORIGINAL_HOME}/zsh/.zprofile" ]; then
  export DOTFILES_DOT_ZPROFILE_LOADING=1
  . "${DOTFILES_ORIGINAL_HOME}/zsh/.zprofile"
  unset DOTFILES_DOT_ZPROFILE_LOADING
fi

if [ -f ~/.profile ]; then
  . "$HOME/.profile"
fi
