#!/bin/sh -eu

if ! command -v systemctl >/dev/null 2>&1; then
	echo "systemctl command not found. Kanata installation canceled."
	return
fi

service_file_path="$DOTPATH/configs/kanata/kanata.service"
link_dir_path="$HOME/.config/systemd/user"

mkdir -p "$link_dir_path"
ln -snfv "$service_file_path" "$link_dir_path"

if ! command -v kanata >/dev/null 2>&1; then
	echo "kanata command not found. Enable systemd service canceled."
	return
fi

systemctl --user daemon-reload
systemctl --user enable --now kanata.service
