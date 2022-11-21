#!/usr/bin/env bash
#
if [ -f ~/.bashrc ]; then
  . "$HOME/.bashrc"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# add cargo path
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
