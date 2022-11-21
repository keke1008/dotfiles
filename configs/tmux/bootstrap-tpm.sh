#!/usr/bin/env sh

tmux display -p "LAUNCHING"

# If TMP is installed
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    # Initialize TPM
    "$HOME/.tmux/plugins/tpm/tpm"
    return
fi

# If git is not found
if ! type "git" > /dev/null; then
    return
fi

# Install TPM
tmux display "Installing TPM..."
git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
tmux display "TPM instalattion completed"

# Initialize TPM
"$HOME/.tmux/plugins/tpm/tpm"

# Install plugins
tmux display -p "Installing plugins..."
"$HOME/.tmux/plugins/tpm/bindings/install_plugins"
tmux display -p "Plugin instalattion completed"
