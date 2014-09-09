#! /bin/sh
command="$@"

output="$("$@" 2>&1)"
result="$?"
var="$command resulted in a "
if [ "$result" -eq "0" ]; then
    var+="success"
else
    var+="failure"
fi

var+=" with result $result"
if [ -n "$output" ]; then
	var+=" and output:\n$output"
fi
if [ -n "$custom_log_file" ]; then
    var="$(echo "$var" | sed -e "s#$HOME#~#g")"
    var="[$(date)] $var"
    if [ ! -f "$custom_log_file" ]; then
	    :  > "$custom_log_file"
    fi
    printf "$var" >> "$custom_log_file"
    printf "\n" >> "$custom_log_file"
else
    printf "$var"
    printf "\n"
fi
