# shellcheck shell=sh

_DOTFILES_VERSION_LOCK_FILE="${XDG_DATA_HOME}/dotfiles/version.lock"
_DOTFILES_MIGRATION_SCRIPTS_DIR="${_DOTFILES_SCRIPT_HOME}/lib/migrations"

get_current_version() {
	local version_lock_file="${_DOTFILES_VERSION_LOCK_FILE}"
	if ! [ -f "${version_lock_file}" ]; then
		log "info" "No version lock file found"
		return 1
	fi

	cat "${version_lock_file}"
}

get_latest_version() {
	local latest_version
	if ! latest_version="$(find "${_DOTFILES_MIGRATION_SCRIPTS_DIR}" -type f -name '*.sh' | wc -l)" || [ "${latest_version}" -eq 0 ]; then
		log "error" "Failed to find any migration scripts"
		return 1
	fi

	echo "${latest_version}"
}

is_latest_version() {
	local current_version
	if ! current_version=$(get_current_version); then
		log "error" "Failed to get current version"
		return 1
	fi

	local latest_version
	if ! latest_version=$(get_latest_version); then
		log "error" "Failed to get latest version"
		return 1
	fi

	[ "${current_version}" -eq "${latest_version}" ]
}

write_version_lock() {
	if [ "$#" -ne 1 ]; then
		log "error" "write_version_lock requires exactly one argument"
		return 1
	fi

	local version="$1"

	echo "${version}" >"${_DOTFILES_VERSION_LOCK_FILE}"
}

migrate_dotfiles() {
	local current_version
	if ! current_version=$(get_current_version); then
		log "info" "version lock file not found, initializing with skipping migrations"
		write_version_lock "$(get_latest_version)"
		return 0
	fi
	log "info" "current version: ${current_version}"

	for version in $(seq $((current_version + 1)) 99999); do
		local migration_file="${_DOTFILES_MIGRATION_SCRIPTS_DIR}/${version}.sh"
		[ ! -f "${migration_file}" ] && break

		log "info" "Migration script found: ${migration_file}"
		echo '```'
		cat "${migration_file}"
		echo '```'

		printf 'Would you like to run this migration script? [y/N] '
		local answer
		read -r answer
		if [ "${answer}" != "y" ]; then
			log "info" "Exiting migration"
			return 1
		fi

		log "info" "Running migration script: ${migration_file}"
		# shellcheck disable=SC1090
		if ! . "${migration_file}"; then
			log "error" "Failed to run migration script: ${migration_file}"
			return 1
		fi
		log "info" "Migration script ran successfully: ${migration_file}"

		write_version_lock "${version}"
	done
}
