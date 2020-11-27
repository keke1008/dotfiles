#!/bin/sh

SCRIPT_PATH="$(cd $(dirname $0); pwd)"

echo "Create dotfile links"
for dotfile in $SCRIPT_PATH/.??*; do
    [[ ${dotfile##*/} = ".git" ]] && continue
    ln -snfv "$dotfile" "$HOME/${dotfile##*/}"
done
echo "Finish"
