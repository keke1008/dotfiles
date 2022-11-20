#!/bin/sh -eu

# If TPM is not installed
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then

    # If git is not found
    if ! type "git" > /dev/null; then
        return
    fi

    tmux display "Installing TPM..."

    # Install TPM
    git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"

    tmux display "TPM instalattion completed"
fi

# Initialize TPM
"$HOME/.tmux/plugins/tpm/tpm"
