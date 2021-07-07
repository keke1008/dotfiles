#!/bin/sh
[ -z $1 ] && echo "Usage: exp path" || wslpath -w $1 | sed -e 's/\\/\\\\/g' | xargs -r explorer.exe
