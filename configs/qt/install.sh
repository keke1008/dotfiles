#!/bin/sh -eu

mkdir -p "$XDG_CONFIG_HOME/qt5ct"
ln -snfv "$DOTPATH/configs/qt/qt5ct.conf" "$XDG_CONFIG_HOME/qt5ct/qt5ct.conf"
