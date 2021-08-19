#!/bin/sh

set -eu
target_path=$(wslpath -w ${1:-.})
explorer.exe $target_path
