#!/usr/bin/env sh

if [ -d "$HOME/.tmux/plugins/tpm" ]; then # If TMP is installed
	# Initialize TPM
	"$HOME/.tmux/plugins/tpm/tpm"
	exit 0
else
	exit 1
fi
