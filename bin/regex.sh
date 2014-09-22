#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"

function match() {
    if [ "$insensitive" -eq "0" ]; then
        local result="$(echo "$1" | grep -E -i "$2")"
    else
        local result="$(echo "$1" | grep -E "$2")"
    fi

    if [ -n "$result" ]; then
        exit 0
    fi
    exit 1
}

function replace() {

    # using a seprate decleration because
    # local variable declartion as a return code so it overwrote the actual return code
    # http://stackoverflow.com/a/4764877
    local result
    local flags=""
    if [ "$insensitive" -eq "0" ]; then
        flags+="i"
    fi
    if [ "$global" -eq "0" ];then
        flags+="g"
    fi
    result="$( set -o pipefail; echo "$1" | sed -e "s~$2~$3~$flags")"
    if [ "$?" -ne "0" ]; then
        echo "Regex Error: $result"
        exit 2
    fi
    echo "$result"
    exit 0
}

insensitive="1"
global="1"
action=""
help=""
help+="match <string> <regex>, 0 if matches 1 otherwise$nl"
help+="replace <string> <regex_search> <replacement> replace from a string$nl"
help+="i insensitive case matching$nl"
help+="g global replace$nl"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --help)
            usage "$help"
        ;;
        --i)
            insensitive="0"
        ;;
        --g)
            global="0"
        ;;
        --match)
                if [ -n "$action" ]; then
                    argument_error "Cannot do $arg and $action"
            fi
            if [ -z "$1" ] || [ -z "$2" ]; then
                argument_error "$arg requires two arguments"
            fi
            action="$arg"
        ;;
        --replace)
            if [ -z "$1" ]; then
                argument_error "Must have an argument after $arg"
            fi
            if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
                argument_error "$arg requires three arguments"
            fi
            action="$arg"
        ;;
        *)
            argument_error "Invalid Argument $arg"
        ;;
    esac
done

if [ -z "$action" ]; then
    argument_error "Must select an action to preform"
fi

if [ "$action" = "--match"  ]; then
    regex_match "$@"
else
    regex_replace "$@"
fi
