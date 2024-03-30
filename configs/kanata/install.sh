#!/bin/sh -eu

if ! command -v systemctl > /dev/null 2>&1; then
    echo "systemctl command not found. Kanata installation canceled."
    exit
fi

service_file_path="$DOTPATH/configs/kanata/kanata.service"
link_dir_path="$HOME/.config/systemd/user/kanata"

mkdir -p "$link_dir_path"
ln -snfv "$service_file_path" "$link_dir_path"

systemctl --user daemon-reload
systemctl --user enable --now kanata.service
