#!/bin/sh -eu

subscribe() {
	rfkill event wifi 2>/dev/null |
		while read -r _; do
			echo
		done
}

wifi_status() {
	rfkill --json | jq -c '
		[.rfkilldevices[] | select(.type == "wlan").soft]
			| { "enable": any(. != "blocked") }'
}

main() {
	case "$1" in
	status)
		subscribe | while read -r _; do
			wifi_status
		done
		;;
	toggle)
		rfkill toggle wifi
		;;
	*)
		echo "Unknown target $1" >&2
		exit 1
		;;
	esac
}

main "$@"
