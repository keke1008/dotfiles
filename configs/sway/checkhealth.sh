#!/bin/bash -eu

if command -v sway >/dev/null 2>&1; then
	level="error"
else
	level="info"
fi

report_command_exists "info" "sway"
report_command_exists "$level" "waybar" "Status bar"
report_command_exists "$level" "wofi" "Application launcher"
report_command_exists "$level" "alacritty" "Terminal emulator"

report_command_exists "warn" "dunst" "Notification daemon"
report_command_exists "warn" "fcitx5" "Input method"

report_command_exists "info" "grim" "Screenshot utility"
