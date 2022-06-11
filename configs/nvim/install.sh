#!/bin/sh -eu

readonly DIR=$(cd $(dirname $0); pwd)

ln -snfv $DIR/nvim ${XDG_CONFIG_HOME:-$HOME/.config}
