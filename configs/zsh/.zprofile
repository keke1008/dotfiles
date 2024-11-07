# Avoid recursive loading
if [ -n "${DOTFILES_ORIGINAL_LOADING:-}" ]; then
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
  DOTFILES_ORIGINAL_LOADING=1 . "${DOTFILES_ORIGINAL_HOME}/zsh/.zprofile"
fi

if [ -f ~/.profile ]; then
  . "$HOME/.profile"
fi
