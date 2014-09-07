#! /bin/sh

    if [ "$#" -ne "1" ] || [ -z "$1" ]; then
        echo "Must pass a non-blank variable to log_header"
        exit 2
    fi
    if [ -n "$custom_log_file" ]; then
        if [ ! -f "$custom_log_file" ]; then
            : > "$custom_log_file"
        fi
        printf "\n* ----------$1---------- *\n" >> "$custom_log_file"
    else
        printf "\n* ----------$1---------- *\n"
    fi

    exit 0
