#!/bin/sh -eu

report_file_readable "info" "${DOTFILES_LOCAL_HOME}/sh/.profile" "Local profile file"
report_file_readable "info" "${DOTFILES_LOCAL_HOME}/sh/.shrc" "Local rc file"
