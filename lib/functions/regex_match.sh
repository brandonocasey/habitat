#! /bin/sh

result=""
if [ "$#" -lt "2" ] || [ "$#" -gt "3" ]; then
    echo 'Usage:'
    echo "  regex_match <string> <search> <insensitive>"
    echo
    echo "Example:"
    echo "  regex_match 'derp' '^derp$'"
    echo
    exit 2
fi

if [ -n "${3:-}" ]; then
    result="$(echo "$1" | grep -E -i "$2")"
else
    result="$(echo "$1" | grep -E "$2")"
fi

if [ -n "$result" ]; then
    exit 0
fi
exit 1
