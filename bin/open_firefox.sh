#!/bin/sh
'/mnt/c/Program Files/Mozilla Firefox/firefox.exe' $([ -z $1 ] || wslpath -w $1 2> /dev/null || echo $1)
