#!/bin/sh -eu

abort() {
	echo "Error: " "$@" >&2
	exit 1
}

if ! DOTPATH="$(
	cd "$(dirname "$0")"
	pwd
)"; then
	abort "Failed to get DOTPATH"
fi
export DOTPATH
echo "${DOTPATH}" >"${HOME}/.dotpath"
. "${DOTPATH}/scripts/common.sh"

ensure_install_script_file() {
	if [ $# -ne 1 ]; then
		abort "Usage: ensure_install_script file_path"
	fi

	file_path=$1
	if [ ! -f "${file_path}" ]; then
		echo "File does not exist: ${file_path}" >&2
		return 1
	elif [ ! -x "${file_path}" ]; then
		echo "File is not executable: ${file_path}" >&2
		return 1
	fi
}

get_script_file_from_dir() {
	if [ $# -ne 1 ]; then
		abort "Usage: get_script_file_from_dir dir"
	fi

	dir=$1
	dir_name=$(basename "${dir}")
	echo "${DOTPATH}/configs/${dir_name}/install.sh"
}

if [ $# -eq 0 ]; then
	script_dirs="${DOTPATH}/configs/*"
else
	script_dirs="$*"
fi

# check if the given configuration directories are valid
ensured=0
for dir in $script_dirs; do
	file=$(get_script_file_from_dir "${dir}")
	if ! ensure_install_script_file "${file}"; then
		ensured=1
	fi
done
if [ $ensured -eq 1 ]; then
	abort "Some configuration directories do not have valid install.sh"
fi

# install the given directories
for dir in $script_dirs; do
	file=$(get_script_file_from_dir "${dir}")
	# shellcheck disable=SC1090
	. "${file}"
done
