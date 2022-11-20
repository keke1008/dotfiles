#!/bin/sh -eu

export readonly DOTPATH=$(cd $(dirname $0); pwd)

echo $DOTPATH > $HOME/.dotpath

for dir in $DOTPATH/configs/* ; do
  "$dir/install.sh"
done
