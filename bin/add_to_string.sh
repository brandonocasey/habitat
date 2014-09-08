#! /bin/sh

if [ "$#" -ne "2" ] || [ -z "$2" ] || [ -z "$3" ]; then
	echo 'Usage:'
	echo "  add_to_string <string> <thing> <deliminator>"
	echo
	echo "Example:"
	echo '  add_to_string "$PATH" "/etc/nope" ":"'
	echo
	exit 2
fi
string="$1"; shift
add="$1"; shift
deliminator="$1"; shift

if [ -n "$( echo "$string" | grep -E "(^|$deliminator)$add($deliminator|$)")" ]; then
	if [ -n "$string" ]; then
		add=":$add"
	fi
	string+="$add"
fi
echo "$string"
