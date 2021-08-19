#!/bin/sh

set -eu
target_path=$(wslpath -w ${1:-.})
'/mnt/c/Program Files/Mozilla Firefox/firefox.exe' $target_path
