#! /bin/sh

if [ -z "${1:-}" ]; then
    while read var; do
        log "$var"
    done
    return
fi
for var in "$@"; do
    var="$(echo "$var" | sed -e "s#$HOME#~#g")"
    var="[$(date)] $var"
    # newline is seprate so that trailing newlines don't escape it
    if [ -n "$custom_log_file" ]; then
        if [ ! -f "$custom_log_file" ]; then
            :  > "$custom_log_file"
        fi
        printf "$var" >> "$custom_log_file"
        printf "\n" >> "$custom_log_file"
    else
        printf "$var"
        printf "\n"
    fi
done
