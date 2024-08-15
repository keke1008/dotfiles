#!/bin/bash -eu

main() {
	report_file_readable "info" "${DOTFILES_LOCAL_HOME}/sway/local_config" "Local sway config file"

	if command -v sway >/dev/null 2>&1; then
		local level_error="error"
		local level_warn="warn"
	else
		local level_error="info"
		local level_warn="info"
	fi

	report_command_exists "info" "sway"
	report_command_exists "${level_error}" "waybar" "Status bar"
	report_command_exists "${level_error}" "wofi" "Application launcher"
	report_command_exists "${level_error}" "alacritty" "Terminal emulator"

	report_command_exists "${level_warn}" "dunst" "Notification daemon"
	report_command_exists "${level_warn}" "swaybg" "Wallpaper setter"
	report_command_exists "${level_warn}" "swaylock" "Screen locker"
	report_command_exists "${level_warn}" "swayidle" "Idle manager"

	report_command_exists "info" "grim" "Screenshot utility"
}

main
