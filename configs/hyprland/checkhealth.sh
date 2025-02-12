#!/bin/sh -eu

main() {
	report_file_readable "info" "${DOTFILES_LOCAL_HOME}/hyprland/hyprland.conf" "Local config file"
	report_command_exists "info" "hyprctl" "Hyprland WM"

	if command -v hyprctl >/dev/null 2>&1; then
		local level_error="error"
		local level_warn="warn"
	else
		local level_error="info"
		local level_warn="info"
	fi

	report_command_exists "${level_warn}" hyprpanel "Status bar"
	report_command_exists "${level_warn}" hyprlock "Screen locker"
	report_command_exists "${level_warn}" hypridle "Idle manager"
}

main
