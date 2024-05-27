# shellcheck shell=sh

eecho() {
	echo "$@" >&2
}

abort() {
	eecho "$@"
	exit 1
}

prompt_choice() {
	if [ "$#" -lt 2 ]; then
		abort "Usage: promptChoice <prompt> <choice1> [<choice2> ...]"
	fi

	prompt="$1"
	shift

	i=1
	for choice in "$@"; do
		eecho "$i) $choice" >&2
		i=$((i + 1))
	done

	while true; do
		printf "%s: " "$prompt" >&2
		read -r input

		# check if input is 'y'
		if [ "$input" = "y" ]; then
			input=1
		fi

		# check if input is not a number
		if ! [ "$input" -eq "$input" ] 2>/dev/null; then
			eecho "Invalid choice"
			continue
		fi

		# check if input is out of range
		if [ "$input" -le 0 ] || [ "$input" -gt "$#" ]; then
			eecho "Invalid choice"
			continue
		fi

		# return the choice
		# if choice is 1, don't shift. Otherwise, shift $input - 1 times
		for _ in $(seq 2 "$input"); do
			shift
		done
		echo "$1"
		return 0
	done
}

prompt_choice_cached() {
	if [ "$#" -lt 3 ]; then
		abort "Usage: promptChoiceCached <cacheFile> <prompt> <choice1> [<choice2> ...]"
	fi

	cache_file="$1"
	shift

	# check if cache file exists and contains a valid choice
	if [ -r "$cache_file" ]; then
		cached_choice="$(cat "$cache_file")"
		for choice in "$@"; do
			if [ "$choice" = "$cached_choice" ]; then
				echo "$cached_choice"
				return 0
			fi
		done
	fi

	# prompt the user
	cached_choice="$(prompt_choice "$@")"
	mkdir -p "$(dirname "$cache_file")"
	echo "$cached_choice" >"$cache_file"
	echo "$cached_choice"
}
