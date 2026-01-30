#!/bin/sh -eu

subscribe() {
	pactl subscribe | grep sink |
		while read -r _; do
			echo
		done
}
