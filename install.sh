#!/bin/sh -eu

export readonly DOTPATH=$(cd $(dirname $0); pwd)
export XDG_CONFIG_HOME=$HOME/.config

echo $DOTPATH > $HOME/.dotpath

for dir in $DOTPATH/configs/* ; do
  "$dir/install.sh"
done
