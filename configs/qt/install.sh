#!/bin/sh -eu

mkdir -p "$XDG_CONFIG_HOME/qt5ct"
stash_and_link "qt" "${XDG_CONFIG_HOME}/qt5ct/qt5ct.conf" "qt5ct.conf"
