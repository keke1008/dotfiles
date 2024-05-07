#!/bin/sh -eu

readonly FISH_CONFIG_DIR="$XDG_CONFIG_HOME/fish"

mkdir -p "$FISH_CONFIG_DIR"
ln -snfv "$DOTPATH/configs/fish/config.fish" "$FISH_CONFIG_DIR"

for dir in "functions" "themes"; do
	mkdir -p "$FISH_CONFIG_DIR/$dir"
	find "$DOTPATH/configs/fish/$dir" -type f -exec ln -snfv {} "$FISH_CONFIG_DIR/$dir" \;
done
