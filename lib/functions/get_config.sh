#! /bin/sh

if [ -z "$1" ]; then
    exit 2
fi
config=""
if [ -z "$2" ]; then
    exit 2
fi

config="$2"
if [ ! -f "$config" ]; then
    touch "$config"
fi

echo "$(cat "$config" | grep "$1=" | sed -e "s/$1=\"//" | sed -e 's/"$//')"
