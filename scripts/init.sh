#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/log.sh"
. "${DOTPATH}/scripts/lib/config_directory.sh"

enable_systemd_units() {
	if ! command -v systemctl >/dev/null 2>&1; then
		log "info" "systemctl not found, skipping enabling systemd unit: ${unit_name}"
		return
	fi

	local unit_dir
	unit_dir="$(config_dirname_to_path "${DOTFILES_INIT_CONFIG_NAME}")/systemd-units"
	if [ ! -d "${unit_dir}" ]; then
		log "error" "No systemd-units directory found in ${DOTFILES_INIT_CONFIG_NAME}"
		return
	fi

	local unit_file
	for unit_file in "${DOTPATH}/configs/${DOTFILES_INIT_CONFIG_NAME}/systemd-units/"*; do
		local unit_filename
		unit_filename="$(basename "${unit_file}")"

		if ! systemctl --user --quiet is-enabled "${unit_filename}"; then
			log "info" "Enabling systemd unit: ${unit_filename}"
			systemctl --user enable --now "${unit_filename}"
		fi
	done
}

enable_systemd_unit() {
	local unit_name="$1"

	if ! command -v systemctl >/dev/null 2>&1; then
		log "info" "systemctl not found, skipping enabling systemd unit: ${unit_name}"
		return
	fi

	if ! systemctl --user --quiet is-enabled "${unit_name}"; then
		log "info" "Enabling systemd unit: ${unit_name}"
		systemctl --user enable --now "${unit_name}"
	fi
}

main() {
	if [ $# -gt 1 ]; then
		abort "Usage: $0 [config_dir_path]"
	fi

	if command -v systemctl >/dev/null 2>&1; then
		log "info" "Reloading systemd user daemon"
		systemctl --user daemon-reload
	fi

	local config_dirnames
	if [ $# -eq 1 ]; then
		config_dirnames="$1"
	else
		config_dirnames="$(enumerate_config_dirname | filter_file_exists "init.sh")"
	fi

	local config_dirname
	for config_dirname in ${config_dirnames}; do
		log "info" "Running init script for: ${config_dirname}"

		local init_script
		init_script="$(config_dirname_to_path "${config_dirname}")/init.sh"
		if [ ! -f "${init_script}" ]; then
			log "error" "No init.sh found in ${config_dirname}"
			set_exit_code 1
			continue
		fi

		export DOTFILES_INIT_CONFIG_NAME="${config_dirname}"
		# shellcheck disable=SC1090
		if ! . "${init_script}"; then
			set_exit_code 1
			continue
		fi
	done

	exit_with_stored_code
}

main "$@"
