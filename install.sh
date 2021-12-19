#!/bin/sh

# save the absolute path to this repository
export DOTPATH=$(cd $(dirname $0); pwd)
echo "$DOTPATH" > $HOME/.dotpath

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

for dir in $DOTPATH/configs/* ; do
  "$dir/install.sh" $dir
done
