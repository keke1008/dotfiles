get_current_version() {
	local version_lock_file="${XDG_DATA_HOME}/dotfiles/version.lock"
	if [ -f "${version_lock_file}" ]; then
		cat "${version_lock_file}"
	else
		echo 0
	fi
}

migrate_dotfiles() {
	local current_version
	if ! current_version=$(get_current_version); then
		log "error" "Failed to get current version"
		return 1
	fi
	log "info" "current version: ${current_version}"

	for version in $(seq $((current_version + 1)) 99999); do
		local migration_file="${DOTPATH}/scripts/lib/migrations/${version}.sh"
		[ ! -f "${migration_file}" ] && break

		log "info" "Migration script found: ${migration_file}"
		echo '```'
		cat "${migration_file}"
		echo '```'

		echo -n "Would you like to run this migration script? [y/N] "
		local answer
		read -r answer
		if [ "${answer}" != "y" ]; then
			log "info" "Exiting migration"
			return 1
		fi

		log "info" "Running migration script: ${migration_file}"
		if ! source "${migration_file}"; then
			log "error" "Failed to run migration script: ${migration_file}"
			return 1
		fi
		log "info" "Migration script ran successfully: ${migration_file}"

		echo "${version}" >"${XDG_DATA_HOME}/dotfiles/version.lock"
		log "info" "Updated version to ${version}"
	done
}
