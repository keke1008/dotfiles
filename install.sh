#!/bin/sh -eu

readonly DIR=$(cd $(dirname $0); pwd)

for dir in $DIR/configs/* ; do
  "$dir/install.sh"
done
