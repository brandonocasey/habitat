#! /bin/sh
#
# shared.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

nl="
"



function _print_error() {
    local exit_code="$1"; shift
    for error in "$@"; do
        echo "$error" 1>&2
    done
    exit "$exit_code"
}
function failure() {
    _print_error "1" "$@"
}

function argument_error() {
    _print_error "2" "$@"

}

function validation_error() {
    _print_error "2" "$@"
}

# Example:
# THINGS=""
# THINGS+="--thing|t thing it woo $nl"
# THINGS+="--ping|p ping it doop $nl"
# THINGS+="--foo|f  foo that stuff $nl"
# THINGS+="--bar|b  The bar $nl"

# usage "$THINGS"
function usage() {
    local items="$1"; shift
    echo
    echo "  ./$(basename "$0") <options>"
    echo
    items+="help Show help options"
    local max_length="$(
        local length="0"
        while read -r item; do
            for var in $item; do
                if [ "$length" -lt "${#var}" ]; then
                    length="${#var}"
                fi
                continue;
            done
        done <<< "$items"
        echo "$((length+1))"
    )"

    (while read -r item; do
        local real_item=""
        for var in $item; do
            real_item+="$var "
            if [ "$real_item" = "$var " ]; then
                real_item="  --$real_item"
                local length="${#var}"
                length=$((max_length-length))
                real_item+="$(printf "%-${length}s" " ")"
            fi
        done
        echo "$real_item"
    done <<< "$items")
    echo
    exit 0
}
