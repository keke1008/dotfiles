#!/bin/sh

fish_dir=$XDG_CONFIG_HOME/fish

mkdir -p $fish_dir
ln -snfv $1/config.fish $fish_dir
