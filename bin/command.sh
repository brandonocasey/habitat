#! /bin/sh
source "$( cd "$(dirname $0 )/.." && pwd)/lib/main.sh"


function log_async_result() {
    local line
    while read line; do
        echo "Async $@: $line"
    done
} >> "$log"

function async_command() {
    (echo "$("$@" 2>&1; echo "Return code: $?")" | log_async_result "$@" &)
    exit 0
}

function is_a_command() {

    if command -v "$1" >/dev/null; then
        exit 0
    fi
    exit 1

}

action=""
opt "async_command|a" "<log> <command> Run an Async Command"
opt "is_a_command|i"  "<binary> Check if a command is valid"
parse_args "$@"
while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        --is_a_command|-is_a_command|-i|--i)
            if [ -z "$1" ]; then
                error "$arg requires an argument"
            fi
            is_a_command "$1"
        ;;
        --async_command|-async_command|-a|--a)
            if [ -z "$1" ] || [ -z "$2" ]; then
                error "$arg requires two arguments"
            fi
            log="$1"; shift
            async_command "$@"
        ;;
        *)
            error "Invalid Argument $arg"
        ;;
    esac
done

