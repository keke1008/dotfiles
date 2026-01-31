#!/bin/sh -eu

main() {
	declare_systemd_unit_dir_link

	if ! command -v systemctl >/dev/null 2>&1; then
		return
	fi

	# shellcheck disable=SC1091
	if (. /etc/os-release && [ "${ID}" = "nixos" ]); then
		return
	fi

	mkdir -p "${XDG_CONFIG_HOME}/systemd/user"
	declare_config_link "${XDG_CONFIG_HOME}/systemd/user/kanata.service" "kanata.service"

	if ! command -v kanata >/dev/null 2>&1; then
		return
	fi

	if [ "${DOTFILES_INSTALL_MODE}" = "install" ]; then
		# Check if kanata service is already enabled
		if ! systemctl --user --quiet is-enabled kanata.service; then
			systemctl --user daemon-reload
			systemctl --user enable --now kanata.service
		fi
	else
		if systemctl --user --quiet is-enabled kanata.service; then
			systemctl --user disable --now kanata.service
		fi
	fi
}

main
