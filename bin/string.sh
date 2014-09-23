#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"

function split() {
    local line=""
    (while read line; do
        (IFS="$delim"
            for i in $line; do
                echo "$i"
            done)
    done <<< "$all_string")
}

function join() {
    local unique="$1"; shift

    (
    local string=""
    IFS="$nl"
    for part in $all_string;do
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
action=""
opt "split" "<delim> split a string on a deliminator"
opt "join"  "<delim> join a string on a deliminator"
opt "joinu" "<delim> join a string on a deliminator, with no duplicates"
parse_args "$@"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --split|--join|--joinu)
            if [ -z "$1" ]; then
                error "$arg requires an argument"
            fi
            if [ -n "$action" ]; then
                error "Cannot $arg and $action"
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
done
if [ -z "$delim" ]; then
    error "deliminator must be defined"
fi

if [ "$action" = "--split" ]; then
    split
elif [ "$action" = "--join" ]; then
    join "1"
elif [ "$action" = "--joinu" ]; then
    join "0"
fi

exit 0
