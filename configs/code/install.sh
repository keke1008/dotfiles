#!/bin/sh -eu

SRC_DIR="$DOTPATH/configs/code"
CODE_OSS_DIR="$XDG_CONFIG_HOME/Code - OSS/User"
VSCODE_DIR="$XDG_CONFIG_HOME/Code/User"

for CODE_DIR in "$CODE_OSS_DIR" "$VSCODE_DIR"; do
	mkdir -p "$CODE_DIR"
	ln -snvf "$SRC_DIR/keybindings.json" "$CODE_DIR"
	ln -snvf "$SRC_DIR/settings.json" "$CODE_DIR"
done
