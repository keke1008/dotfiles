#!/bin/sh -eu

mkdir -p "$HOME/.config/dunst"
ln -snfv "$DOTPATH/configs/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"
