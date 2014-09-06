#! /bin/sh

function get_config() {
    if [ -z "$1" ]; then
        return 2
    fi
    config=""
    if [ -n "$2" ]; then
        config="$2"
    elif [ -n "$CUSTOM_CONFIG_FILE" ]; then
        config="$CUSTOM_CONFIG_FILE"
    else
        return 2
    fi
    if [ ! -f "$config" ]; then
        touch "$config"
    fi

    local result="$(cat "$config" | grep "$1=" | sed -e "s/$1=\"//" | sed -e 's/"$//')"
    echo "$result"
}
