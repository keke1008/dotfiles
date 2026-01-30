#!/bin/sh -eu

subscribe_players() {
	playerctl metadata --all-players -F -f '{{playerName}}' || true 2>/dev/null |
		while read -r _; do
			echo
		done
}

subscribe_player_details() {
	playerctl metadata --all-players -F -f '{{position}}{{mpris:length}}{{playerName}}{{status}}{{artist}}{{title}}' || true 2>/dev/null |
		while read -r _; do
			echo
		done
}

audio_players() {
	(playerctl metadata --all-players -f '{{playerName}}' 2>/dev/null || true) |
		jq -Rc |
		jq -sc 'sort'
}

audio_player_details() {
	format=$(printf '{{position}}\t{{mpris:length}}\t{{status}}\t{{playerName}}\t{{artist}}\t{{title}}')
	(playerctl metadata --all-players -f "${format}" 2>/dev/null || true) |
		jq -Rc '
			split("\t")
			| {
				position: try (.[0] | tonumber) catch 0,
				length: try (.[1] | tonumber) catch 0,
				status: .[2],
				player: .[3],
				artist: .[4],
				title: .[5],
			}
			| {
				(.player): {
					position: [try (.position / .length * 100) catch 0, 100] | min,
					playing: .status == "Playing",
					player: .player,
					artist: .artist,
					title: .title,
					time: .position / 1000 / 1000 | strftime("%H:%M:%S"),
				}
			}' |
		jq -sc 'add | . // {}'
}

main() {
	case "$1" in
	players)
		audio_players
		subscribe_players | while read -r _; do
			audio_players
		done
		;;
	player-details)
		audio_player_details
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
