#! /bin/sh

function is_installed() {
	if [ "$#" -ne "1" ] || [ -z "$1" ]; then
		echo 'Usage:'
		echo "  is_installed <name>"
		echo
		echo "Example:"
		echo "  is_installed ack"
		echo
		return 2
	fi

	if command -v "$1" >/dev/null; then
		return 0
	fi
	return 1
}
