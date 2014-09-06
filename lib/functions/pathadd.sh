#! /bin/sh

function pathadd() {
	if [ "$#" -ne "1" ] || [ -z "$1" ]; then
		echo 'Usage:'
		echo "  pathadd <dir>"
		echo
		echo "Example:"
		echo "  pathadd '/etc/nope'"
		echo
		return 2
	fi
	local binary="$(echo "$1" | sed -e 's~/$~~')"

	if [ -n "$( echo "$PATH" | grep -E "(^|:)$binary(:|$)")" ]; then
		if [ -n "$PATH" ]; then
			binary=":$binary"
		fi
		PATH+="$binary"
		return 0
	fi
	return 1

}
