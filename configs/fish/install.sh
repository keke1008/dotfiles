#!/bin/sh -eu

readonly DIR=$(cd $(dirname $0); pwd)

readonly FISH_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/fish

mkdir -p $FISH_DIR/functions

ln -snfv $DIR/config.fish $FISH_DIR
find $DIR/functions -type f | xargs ln -snfv -t $FISH_DIR/functions
