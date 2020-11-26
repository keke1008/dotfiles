#!/bin/sh

echo "Create dotfile links"
for dotfile in .??*; do
    [[ $dotfile = ".git" ]] && continue
    ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
echo "finish"
