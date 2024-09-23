#!/bin/sh -eu

if command -v waybar >/dev/null 2>&1; then
	level="error"
else
	level="info"
fi

report_command_exists "info" "waybar"
report_command_exists "$level" "pactl"
report_command_exists "$level" "pavucontrol"
