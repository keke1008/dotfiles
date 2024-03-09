#!/bin/sh -eu

export readonly DOTPATH=$(cd $(dirname $0); pwd)
export XDG_CONFIG_HOME=$HOME/.config

echo $DOTPATH > $HOME/.dotpath

if [ $# -eq 0 ]; then
    echo "Usage: $0 [ all | nvim | fish | ... ] [ nvim | fish | ... ] ..."
    exit 1
fi

# check if the given configuration directories are valid
for dir in $@; do
    if [ $dir = "all" ]; then
        continue
    fi
    if [ ! -x $DOTPATH/configs/$dir/install.sh ]; then
        echo "Error: $dir is not a valid configuration directory"
        exit 1
    fi
done

# install the given directories
for dir in $@; do
    if [ $dir = "all" ]; then
        for d in $DOTPATH/configs/*; do
            $d/install.sh
        done
    else
        $DOTPATH/configs/$dir/install.sh
    fi
done
