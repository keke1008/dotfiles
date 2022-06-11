#!/bin/sh -eu

for dir in $DOTPATH/configs/* ; do
  "$dir/install.sh"
done
