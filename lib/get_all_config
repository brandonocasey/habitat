#! /bin/sh

function get_all_config() {
    config=""
    if [ -n "$1" ]; then
        config="$1"
    elif [ -n "$CUSTOM_CONFIG_FILE" ]; then
        config="$CUSTOM_CONFIG_FILE"
    else
        return 2
    fi
    if [ ! -f "$config" ]; then
        touch "$config"
    fi

    local result="$(cat "$config" | grep ".*=.*" | sed -e "s/=.*//" | sed -e 's/=//' | xargs)"
    echo "$result"
}
