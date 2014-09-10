#! /bin/sh


if [ -z "$1" ]; then
	echo "Command must be defined"
    exit 2
fi

if [ -z "$custom_log_file" ]; then
	echo "log file is not defined"
    exit 2
fi

function log_async_result() {
    local line
    while read line; do
	echo "Async $@: $line" >> "$custom_log_file"
    done
}

(echo "$("$@" 2>&1; echo "Return code: $?")" | log_async_result "$@" &)
