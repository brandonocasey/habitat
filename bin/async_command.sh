#! /bin/sh


if [ -z "$1" ]; then
	echo "Command must be defined"
    exit 2
fi

if [ -z "$custom_log_file" ]; then
	echo "log file is not defined"
    exit 2
fi

("$@" 2>&1 && echo "Result code $?" | while read line; do echo "Async '$@' returned : $line" 2>&1 >> "$custom_log_file"; done &)
