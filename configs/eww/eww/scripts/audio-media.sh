#!/bin/sh -eu

_subscribe() {
	echo
	pactl subscribe | grep --line-buffered "${1}" |
		while read -r _; do
			echo
		done
}

subscribe_sink() {
	_subscribe "sink"
}

subscribe_source() {
	_subscribe "source"
}

default_sink_volume() {
	wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null |
		sed -e 's/^Volume: \([0-9.]\+\)$/\1/' |
		jq -c '{ volume: . * 100 | ceil }'
}

get_status() {
	wpctl get-volume "$1" 2>/dev/null |
		jq -Rc '{
			volume: split(" ")[1] | try tonumber catch 1 | . * 100 | round,
			muted: test("\\[MUTED\\]")
		}'
}

default_sink_status() {
	wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null |
		jq -Rc '{
			volume: split(" ")[1] | try tonumber catch 1 | . * 100 | round,
			muted: test("\\[MUTED\\]")
		}'
}

default_source_status() {
	wpctl
}

DEFAULT_SINK="@DEFAULT_AUDIO_SINK@"
DEFAULT_SOURCE="@DEFAULT_AUDIO_SOURCE@"

main() {
	case "$1" in
	sink-volume)
		subscribe | while read -r _; do
			default_sink_volume
		done
		;;
	sink-status)
		subscribe_sink | while read -r _; do
			get_status "${DEFAULT_SINK}"
		done
		;;
	source-status)
		subscribe_source | while read -r _; do
			get_status "${DEFAULT_SOURCE}"
		done
		;;
	set-sink-volume)
		wpctl set-volume "${DEFAULT_SINK}" "$2"
		;;
	set-source-volume)
		wpctl set-volume "${DEFAULT_SOURCE}" "$2"
		;;
	toggle-sink-mute)
		wpctl set-mute "${DEFAULT_SINK}" toggle
		;;
	toggle-source-mute)
		wpctl set-mute "${DEFAULT_SOURCE}" toggle
		;;
	*)
		echo "Unknown target $1" >&2
		exit 1
		;;
	esac
}

main "$@"
