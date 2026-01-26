#!/bin/sh -eu

subscribe_players() {
	playerctl metadata -F -f '{{playerName}}' 2>/dev/null |
		while read -r _; do
			echo
		done
}

subscribe_player_details() {
	playerctl metadata -F -f '{{position}}{{mpris:length}}{{playerName}}{{status}}{{artist}}{{title}}'
}

audio_players() {
	playerctl metadata --all-players -f '{{playerName}}' |
		jq -Rc |
		jq -sc
}

audio_player_details() {
	format=$(printf '{{position}}\t{{mpris:length}}\t{{status}}\t{{playerName}}\t{{artist}}\t{{title}}')
	playerctl metadata --all-players -f "${format}" 2>/dev/null |
		jq -Rc '
			split("\t")
			| {
				(.[3]): {
					position: try ((.[0] | tonumber) / (.[1] | tonumber) * 100) catch 0,
					playing: .[2] == "Playing",
					player: .[3],
					artist: .[4],
					title: .[5],
				}
			}' |
		jq -sc 'add'
}

main() {
	case "$1" in
	players)
		subscribe_players | while read -r _; do
			audio_players
		done
		;;
	player-details)
		subscribe_player_details | while read -r _; do
			audio_player_details
		done
		;;
	toggle)
		playerctl --player="$2" play-pause
		;;
	skip-previous)
		playerctl --player="$2" previous
		;;
	skip-next)
		playerctl --player="$2" next
		;;
	*)
		echo "Unknown target $1" >&2
		exit 1
		;;
	esac
}

main "$@"
