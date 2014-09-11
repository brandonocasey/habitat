#! /bin/sh
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Must pass two args <key> and <config>"
    exit 2
fi

config="$2"

if [ ! -f "$config" ]; then
    touch "$config"
    echo "Config does not exist"
    exit 0
fi

result="$(cat "$config" | grep "$1=")"
if [ -z "$result" ]; then
    echo "$1 not in config"
    exit 1
else
    echo "deleted $1 from $config"
    new_config="$(cat "$config" | sed -e "s~$1=\".*\"~~")"
    printf "%s" "`printf "%s" "$new_config"`" > "$config"
    exit 0
fi

exit 1
