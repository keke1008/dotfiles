#!/bin/bash

# save the absolute path to this repository
DOTPATH=$(cd $(dirname $0); pwd)
echo "$DOTPATH" > $HOME/.dotpath


# link files
create_link() {
  from_dir=$1
  to_dir=$2
  ls -A1 $from_dir | xargs -I {} ln -snfv $from_dir/{} $to_dir
}
create_link $DOTPATH/home $HOME
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
create_link $DOTPATH/xdg_config_home $XDG_CONFIG_HOME
