#!/bin/sh
SCRIPT_DIR="$(cd $(dirname $0); pwd)"

ls -A1 ${SCRIPT_DIR} | grep -vE "^([^.]|\.git)" | xargs -I FILENAME ln -snfv ${SCRIPT_DIR}/FILENAME ${HOME}/temp/FILENAME
