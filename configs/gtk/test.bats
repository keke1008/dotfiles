#!/usr/bin/env bats

@test "can instal and restore gtk 3.0 and 4.0 config" {
	local ORIGINAL_GTK_3_0_SETTINGS_CONTENTS="# Original gtk-3.0/settings.ini contents"
	local ORIGINAL_GTK_3_0_SETTINGS_PATH="${XDG_CONFIG_HOME}/gtk-3.0/settings.ini"
	local DOTFILES_GTK_3_0_SETTINGS_PATH="${DOTPATH}/configs/gtk/gtk-3.0-settings.ini"

	local ORIGINAL_GTK_4_0_SETTINGS_CONTENTS="# Original gtk-4.0/settings.ini contents"
	local ORIGINAL_GTK_4_0_SETTINGS_PATH="${XDG_CONFIG_HOME}/gtk-4.0/settings.ini"
	local DOTFILES_GTK_4_0_SETTINGS_PATH="${DOTPATH}/configs/gtk/gtk-4.0-settings.ini"

	mkdir -p "${XDG_CONFIG_HOME}/gtk-3.0"
	echo "${ORIGINAL_GTK_3_0_SETTINGS_CONTENTS}" >"${ORIGINAL_GTK_3_0_SETTINGS_PATH}"

	mkdir -p "${XDG_CONFIG_HOME}/gtk-4.0"
	echo "${ORIGINAL_GTK_4_0_SETTINGS_CONTENTS}" >"${ORIGINAL_GTK_4_0_SETTINGS_PATH}"

	run "${DOTPATH}/dot" install gtk
	[ "${status}" -eq 0 ]
	[ "$(readlink "${ORIGINAL_GTK_3_0_SETTINGS_PATH}")" = "${DOTFILES_GTK_3_0_SETTINGS_PATH}" ]
	[ "$(readlink "${ORIGINAL_GTK_4_0_SETTINGS_PATH}")" = "${DOTFILES_GTK_4_0_SETTINGS_PATH}" ]

	run "${DOTPATH}/dot" restore gtk
	[ "${status}" -eq 0 ]
	[ "$(cat "${ORIGINAL_GTK_3_0_SETTINGS_PATH}")" = "${ORIGINAL_GTK_3_0_SETTINGS_CONTENTS}" ]
	[ "$(cat "${ORIGINAL_GTK_4_0_SETTINGS_PATH}")" = "${ORIGINAL_GTK_4_0_SETTINGS_CONTENTS}" ]
}
