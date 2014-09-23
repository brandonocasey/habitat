#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"

function split() {
    local line=""
    (while read line; do
        (IFS="$delim"
            for i in $line; do
                echo "$i"
            done)
    done <<< "$@")
}

function join() {
    local unique="$1"; shift

    (
        local string=""
        IFS="$nl"
        for part in $@;do
            if [ "$unique" -eq "0" ] && [ -n "$string" ]; then
                if [ -n "$(echo "$string" | grep -E "(^|$delim)$part($delim|$)")" ]; then
                    continue;
                fi
            fi
            if [ -z "$string" ]; then
                string+="${part}"
            else
                string+="${delim}${part}"
            fi
        done
        echo "$string"
    )
}

function fix_delim() {
    if [ "$1" = '\n' ]; then
        echo "$nl"
    fi
    echo "$1"
}

all_string=""
# if stdin is a tty: process command line
if [ ! -t 0 ]; then
    while read var; do
        set -- "$@" "$var"
    done
fi

action=""
opt "split" "<delim> split a string on a deliminator"
opt  "join"  "<delim> join a string on a deliminator"
opt "joinu" "<delim> join a string on a deliminator, with no duplicates"
parse_args "$@"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --help)
        usage "$help"
        ;;
        --split|--join|--joinu)
            if [ -z "$1" ]; then
                argument_error "$arg requires an argument"
            fi

            if [ -n "$action" ]; then
                argument_error "Cannot $arg and $action"
            fi
            delim="$(fix_delim "$1")"; shift
            action="$arg"
        ;;
        *)
            if [ -z "$all_string" ]; then
                all_string+="$arg"
            else
                all_string+="${nl}$arg"
            fi
        ;;
    esac
d ne
if [ -z "$delim" ]; then
    validation_error "deliminator must be defined"
fi

if [ "$action" = "--split" ]; then
    split "$all_string"
elif [ "$action" = "--join" ]; then
    join "1" "$all_string"
elif [ "$action" = "--joinu" ]; then
    join "0" "$all_string"
fi

exit 0
