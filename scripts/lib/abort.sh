# shellcheck shell=sh

abort() {
	echo "Error: " "$@"
	exit 1
}
