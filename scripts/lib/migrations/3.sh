# shellcheck shell=sh
# Remove old kanata.service symlink file if it exists

OLD_SYMLINK_DESTINATION="${DOTPATH}/configs/kanata/kanata.service"
OLD_SYMLINK_PATH="${XDG_CONFIG_HOME}/systemd/user/kanata.service"

main() {
	if ! [ -L "${OLD_SYMLINK_PATH}" ]; then
		log "info" "No old kanata.service symlink found at ${OLD_SYMLINK_PATH}. Skipping removal."
		return
	fi

	if ! [ "$(realpath "${OLD_SYMLINK_PATH}")" = "$(realpath "${OLD_SYMLINK_DESTINATION}")" ]; then
		log "info" "The symlink at ${OLD_SYMLINK_PATH} does not point to ${OLD_SYMLINK_DESTINATION}. Skipping removal."
		return
	fi

	log "info" "Removing old kanata.service symlink at ${OLD_SYMLINK_PATH}"
	if ! rm "${OLD_SYMLINK_PATH}"; then
		log "error" "Failed to remove old kanata.service symlink at ${OLD_SYMLINK_PATH}"
		return 1
	fi

	log "info" "Successfully removed old kanata.service symlink at ${OLD_SYMLINK_PATH}"
}

main
