if [ -n "${DOTFILES_DOT_BASH_PROFILE_LOADING:-}" ]; then
	return 0
fi

# Bootstrapping
if [ -r "$HOME/.dotpath" ] && DOTPATH=$(cat "$HOME/.dotpath"); then
	eval "$("${DOTPATH}/dot" shellenv)"
else
	echo "Error: Failed to get DOTPATH" >&2
	return 1
fi

if [ -r "${DOTFILES_ORIGINAL_HOME}/bash/.bash_profile" ]; then
	export DOTFILES_DOT_BASH_PROFILE_LOADING=1
	. "${DOTFILES_ORIGINAL_HOME}/bash/.bash_profile"
	unset DOTFILES_DOT_BASH_PROFILE_LOADING
fi

if [ -f ~/.profile ]; then
	. "$HOME/.profile"
fi

if [ -f ~/.bashrc ]; then
	. "$HOME/.bashrc"
fi
