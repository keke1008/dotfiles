#!/bin/sh -eu

readonly DIR=$(cd $(dirname $0); pwd)

ln -snfv "$DIR/.tmux.conf" "$HOME"
