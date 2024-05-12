#!/bin/sh -eu

SRC_DIR="$DOTPATH/configs/code"

if [ "$(uname)" = "Darwin" ]; then
	CODE_BASE_DIR="$HOME/Library/Application Support/"
	CODE_OSS_DIR="$CODE_BASE_DIR/Code/User"
	VSCODE_DIR="$CODE_BASE_DIR/Code - OSS/User"
else
	CODE_OSS_DIR="$XDG_CONFIG_HOME/Code - OSS/User"
	VSCODE_DIR="$XDG_CONFIG_HOME/Code/User"
fi

for CODE_DIR in "$CODE_OSS_DIR" "$VSCODE_DIR"; do
	mkdir -p "$CODE_DIR"
	ln -snvf "$SRC_DIR/keybindings.json" "$CODE_DIR"
	ln -snvf "$SRC_DIR/settings.json" "$CODE_DIR"
done

# for remote development
if [ -n "${SSH_CLIENT:-''}" ] || [ -n "${SSH_TTY:-''}" ]; then # Use parameter expansion to prevent an 'undefined variable' error
	VSCODE_SERVER_DIR="$HOME/.vscode-server/data/Machine"
	mkdir -p "$VSCODE_SERVER_DIR"
	ln -snvf "$SRC_DIR/settings.json" "$VSCODE_SERVER_DIR"
fi
