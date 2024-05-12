#!/usr/bin/env sh

if ! command -v "git" >/dev/null; then
	echo "Git is not installed. Please install Git and try again."
	return
fi

git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
"$HOME/.tmux/plugins/tpm/tpm"
"$HOME/.tmux/plugins/tpm/bindings/install_plugins"
