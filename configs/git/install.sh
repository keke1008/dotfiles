#!/bin/sh -eu

readonly SOURCE_DIR=$(cd $(dirname $0); pwd)

ln -snfv $SOURCE_DIR/git ${XDG_CONFIG_HOME:-$HOME/.config}
