#!/bin/bash -eu

if command -v sway >/dev/null 2>&1; then
	level="error"
else
	level="info"
fi

report_command_exists "info" "sway"
report_command_exists "$level" "waybar"
report_command_exists "$level" "wofi"
report_command_exists "$level" "alacritty"
