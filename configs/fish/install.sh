#!/bin/sh -eu

readonly FISH_CONFIG_DIR=$XDG_CONFIG_HOME/fish

mkdir -p $FISH_CONFIG_DIR/functions

ln -snfv $DOTPATH/configs/fish/config.fish $FISH_CONFIG_DIR

for file in $(find $DOTPATH/configs/fish/functions -type f); do
    ln -snfv $file $FISH_CONFIG_DIR/functions
done
