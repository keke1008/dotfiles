#!/bin/sh -eu

mkdir -p "$XDG_CONFIG_HOME/qt5ct"
create_original_home "qt"
stash_and_link "qt" "${XDG_CONFIG_HOME}/qt5ct/qt5ct.conf" "qt5ct.conf"
mark_stashed "qt"
