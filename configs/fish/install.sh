#!/bin/sh

fish_dir=$XDG_CONFIG_HOME/fish

mkdir -p $fish_dir
ln -snfv $1/config.fish $fish_dir

mkdir -p $fish_dir/functions
find $1/functions -type f | xargs ln -snfv -t $fish_dir/functions
