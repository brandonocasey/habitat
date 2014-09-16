#! /bin/sh

function usage() {
	echo
	echo "    ./$(basename "$0") <string> <addition> <deliminator>"
	echo
	echo '    Add an item to a list if it is not already in the list and echo the list'
	echo '    returns 1 if added, 0 if not added, and 2 if error or help is shown'
	echo
	echo '    <string>      The string to add to, can be empty'
	echo '    <addition>    what to try and add'
	echo '    <deliminator> How the list is seperated'
	echo
	exit 2
}
for arg in "$@"; do
	if [ -n "$(echo "$arg" | grep -E '^--?(h|help)')" ]; then
		usage
	fi
done
if [ "$#" -ne "3" ] || [ -z "$2" ] || [ -z "$3" ]; then
	usage
fi

string="$1"; shift
add="$1"; shift
deliminator="$1"; shift
code=1

if [ -z "$(echo "$string" | grep -E "(^|$deliminator)$add($deliminator|$)")" ]; then
	if [ -n "$string" ]; then
		add="$deliminator$add"
	fi
	string+="$add"
	code=0
fi
echo "$string"
exit "$code"
