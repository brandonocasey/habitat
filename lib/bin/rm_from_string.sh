#! /bin/sh
if [ "$#" -ne "3" ]; then
    echo 'Usage:'
    echo "  rm_from_string <string> <remove> <deliminator>"
    echo
    echo "Example:"
    echo '  rm_from_string  "$PATH" "/bin" ":"'
    exit 2
fi

string="$1"; shift
remove="$1"; shift
deliminator="$1"; shift
if [ -n "$(echo "$string" | grep -E "(^|$deliminator)$remove($deliminator|$)")" ]; then
    PATH="$(echo "$string" | sed -e "s~${deliminator}${remove}$~~")"
    PATH="$(echo "$string" | sed -e "s~${remove}${deliminator}~~")"
    exit 0
fi
