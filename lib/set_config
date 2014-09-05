#! /bin/sh

function set_config() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        return 2
    fi

    config=""
    if [ -n "$3" ]; then
        config="$3"
    elif [ -n "$custom_config_file" ]; then
        config="$custom_config_file"
        else
                return 2
    fi

    if [ ! -f "$config" ]; then
        touch "$config"
    fi

    local result="$(cat "$config" | grep "$1=")"
    if [ -z "$result" ]; then
        echo "$1=\"$2\"" >> "$config"
    else
        local new_config="$(cat "$config" | sed -e "s~$1=\".*\"~$1=\"$2\"~")"
        echo "$new_config" > "$config"
    fi
}
