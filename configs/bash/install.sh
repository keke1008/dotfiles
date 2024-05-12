#!/bin/sh -eu

for file in $(find "$DOTPATH/configs/bash/" -type f -name '.*'); do
	ln -snfv "$file" "$HOME"
done
