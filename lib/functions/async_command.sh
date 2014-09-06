#! /bin/sh

function async_command() {
	if [ -z "$1" ] || [ -z "$2" ]; then
	    return 2
	fi
    (eval "$1" 2>&1 | while read line; do echo "Async '$1' returned : $line" 2>&1 >> "$2"; done &)
}
