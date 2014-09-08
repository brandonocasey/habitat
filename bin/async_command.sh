#! /bin/sh


if [ -z "$1" ]; then
    exit 2
fi

if [ -n "$2" ]; then
    log="$2"
elif [ -n "$custom_log_file" ]; then
    log="$custom_log_file"
else
    exit 2
fi

(eval "$1" 2>&1 | while read line; do echo "Async '$1' returned : $line" 2>&1 >> "$2"; done &)
