#!/bin/sh -eu

. "${DOTPATH}/scripts/lib/log.sh"
. "${DOTPATH}/scripts/lib/link_reproducible.sh"

expand_tilde() {
	if [ $# -ne 1 ]; then
		abort "Usage: expand_tilde path"
	fi

	local path="$1"

	case "${path}" in
	"~")
		echo "${HOME}"
		;;
	"~/"*)
		echo "${HOME}/${path#~/}"
		;;
	*)
		echo "$path"
		;;
	esac
}

extract_source_from_line() {
	if [ $# -ne 1 ]; then
		abort "Usage: extract_source_from_line line"
	fi

	echo "$1" | cut -d' ' -f1
}

extract_target_from_line() {
	if [ $# -ne 1 ]; then
		abort "Usage: extract_target_from_line line"
	fi

	echo "$1" | cut -d' ' -f2-
}

process_line() {
	if [ $# -ne 3 ]; then
		abort "Usage: process_line <root_dir> <command> <line>"
	fi

	local root_dir="$1"
	local command="$2"
	local line="$3"

	local source target
	source="$(extract_source_from_line "${line}")"
	target="$(extract_target_from_line "${line}")"

	local abs_source abs_target
	abs_source="${root_dir}/${source}"
	abs_target="$(expand_tilde "${target}")"

	case "${command}" in
	link)
		link_reproducible "${abs_source}" "${abs_target}"
		;;
	unlink)
		unlink_reproducible "${abs_source}" "${abs_target}"
		;;
	*)
		log "error" "Unknown command: ${command}. Use 'link' or 'unlink'"
		return 1
		;;
	esac
}

process_mappings() {
	if [ $# -ne 2 ]; then
		abort "Usage: process_mappings <command> <mapping_file>"
	fi

	local command="$1"
	local mapping_file="$2"

	if [ ! -r "${mapping_file}" ]; then
		abort "Mapping file does not exist or is not readable: ${mapping_file}"
	fi

	local root_dir
	root_dir="$(dirname "$(readlink -f "${mapping_file}")")"

	while IFS= read -r line; do
		if ! process_line "${root_dir}" "${command}" "${line}"; then
			set_exit_code 1
		fi
	done <"${mapping_file}"
}

main() {
	if [ $# -ne 2 ]; then
		abort "Usage: $0 <command> <mapping_file>"
	fi

	local command="$1"
	local mapping_file="$2"

	# Validate command
	case "${command}" in
	link | unlink)
		process_mappings "${command}" "${mapping_file}"
		;;
	*)
		abort "Unknown command: ${command}."
		;;
	esac

	exit_with_stored_code
}

main "$@"
