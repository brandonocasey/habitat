#! /bin/sh
function pathrm() {
    if [ "$#" -ne "1" ] || [ -z "$1" ]; then
        echo 'Usage:'
        echo "  pathrm <dir>"
        echo
        echo "Example:"
        echo "  pathrm '/etc/nope'"
        echo
        return 2
    fi

    local binary="$(regex_replace "$1" 's~/$~~')"
    if [ -n "$(echo "$PATH" | grep -E "(^|:)$binary(:|$)")" ]; then
        PATH="$(echo "$PATH" | sed -e "s~:$binary$~~")"
        PATH="$(echo "$PATH" | sed -e "s~$binary$~~")"
        return 0
    fi
    return 1
}

