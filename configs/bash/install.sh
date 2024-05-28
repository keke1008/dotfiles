#!/bin/sh -eu

ln -snfv "${DOTPATH}/configs/bash/.bashrc" "${HOME}"
ln -snfv "${DOTPATH}/configs/bash/.bash_profile" "${HOME}"
ln -snfv "${DOTPATH}/configs/bash/.inputrc" "${HOME}"
