#!/bin/bash

DOTPATH=$(cd $(dirname $0); pwd)

create_link() {
  from_dir=$1
  to_dir=$2
  ls -A1 $from_dir | xargs -I {} ln -snfv $from_dir/{} $to_dir
}

create_link $DOTPATH/home $HOME
create_link $DOTPATH/xdg_condfig_home ${XDG_CONFIG_HOME:-$HOME/.config}
