#! /bin/sh
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    exit 2
fi

config="$3"

if [ ! -f "$config" ]; then
    touch "$config"
fi

result="$(cat "$config" | grep "$1=")"
if [ -z "$result" ]; then
    echo "$1=\"$2\"" >> "$config"
else
    new_config="$(cat "$config" | sed -e "s~$1=\".*\"~$1=\"$2\"~")"
    echo "$new_config" > "$config"
fi
