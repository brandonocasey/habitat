#! /bin/sh

function regex_match() {
    local result=""
    if [ "$#" -lt "2" ] || [ "$#" -gt "3" ]; then
        echo 'Usage:'
        echo "  regex_match <string> <search> <insensitive>"
        echo
        echo "Example:"
        echo "  regex_match 'derp' '^derp$'"
        echo
        return 2
    fi

    if [ -n "$3" ]; then
        result="$(echo "$1" | grep -E -i "$2")"
    else
        result="$(echo "$1" | grep -E "$2")"
    fi

    if [ -n "$result" ]; then
        return 0
    fi
    return 1
}
