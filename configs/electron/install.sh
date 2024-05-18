#!/bin/sh -eu

ELECTRON_CONFIG_FILE="$DOTPATH/configs/electron/electron-flags.conf"

ln -snfv "$ELECTRON_CONFIG_FILE" "$XDG_CONFIG_HOME/electron27-flags.conf"
ln -snfv "$ELECTRON_CONFIG_FILE" "$XDG_CONFIG_HOME/electron28-flags.conf"
