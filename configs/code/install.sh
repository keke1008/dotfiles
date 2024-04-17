#!/bin/sh -eu

CODE_DIR="$XDG_CONFIG_HOME/Code - OSS/User"

if [ ! -d "$CODE_DIR" ]; then
    echo "Code is not installed. Cancel creating a symlink." 1>&2
    exit 0
fi

ln -snvf "$DOTPATH/configs/code/keybindings.json" "$CODE_DIR/keybindings.json"
