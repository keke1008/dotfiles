#!/bin/sh -eu

subscribe() {
	dbus-monitor --system "type='signal',sender='org.bluez',interface='org.freedesktop.DBus.Properties'" 2>/dev/null \
		| while read -r _; do
			echo
		done
}

bluetooth-status() {
	busctl --json=short get-property org.bluez /org/bluez/hci0 org.bluez.Adapter1 Powered \
		| jq -c '{ powered: .data }'
}

bluetooth-device-status() {
	busctl call --json=short org.bluez / org.freedesktop.DBus.ObjectManager GetManagedObjects \
		| jq -c '[
			.data[0]
			| to_entries[]
			| select(.key | contains("/dev_"))
			| {
				"device": .value["org.bluez.Device1"],
				"battery": .value["org.bluez.Battery1"]
			  }
			| select(.device.Connected.data == true)
			| {
				"name": .device.Name.data // "Unknown",
				"icon": .device.Icon.data // "unknown",
				"battery": .battery.Percentage.data // null,
			  }
		]'
}

main() {
	case "$1" in
		status)
			subscribe | while read -r _; do
				bluetooth-status
			done
			;;
		device-status)
			subscribe | while read -r _; do
				bluetooth-device-status
			done
			;;
		*)
			echo "Unknown target $1" >&2
			exit 1
			;;
	esac
}

main "$@"
