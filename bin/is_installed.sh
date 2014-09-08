#! /bin/sh

if [ "$#" -ne "1" ] || [ -z "$1" ]; then
	echo 'Usage:'
	echo "  is_installed <name>"
	echo
	echo "Example:"
	echo "  is_installed ack"
	echo
	exit 2
fi

if command -v "$1" >/dev/null; then
	exit 0
fi
exit 1
