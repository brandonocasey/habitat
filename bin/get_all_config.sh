#! /bin/sh

config=""
if [ -z "$1" ]; then
    exit 2
fi

config="$1"
if [ ! -f "$config" ]; then
    touch "$config"
fi

echo "$(cat "$config" | grep ".*=.*" | sed -e "s/=.*//" | sed -e 's/=//' | xargs)"
