#!/bin/sh
IGNORE_CASE="^\.git"
SCRIPT_PATH="$(cd $(dirname $0); pwd)"

echo "Create dotfile links"
for dotfile in $SCRIPT_PATH/.??*; do
    echo ${dotfile##*/} | grep -sq $IGNORE_CASE && continue
    ln -snfv "$dotfile" "$HOME/${dotfile##*/}"
done
echo "Finish"
