#! /bin/sh
#
# shared.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

nl="
"
function failure() {
    for failure in "$@"; do
        echo "FAIL: ${failure}" 1>&2
    done
    exit 1
}

function error() {
    for error in "$@"; do
        echo "ERROR: ${error} see --help for help" 1>&2
    done
    exit 2
}

# Example:
# THINGS=""
# THINGS+="thing thing it woo $nl"
# THINGS+="ping ping it doop $nl"
# THINGS+="# 1 - pings the best"
# THINGS+="# 2 - pings the worst"
# THINGS+="foo  foo that stuff $nl"
# THINGS+="bar  The bar $nl"

# Output would be
#
#  ./script.sh <options
#
#  --thing    thing it woo
#  --ping     ping it doop
#               1 - pings the best
#               2 - pings the worst
#  --foo      foo that stuff
#  --bar      The bar
#

# usage "$THINGS"
function usage() {
    local items="$1"; shift
    echo
    if [ -z "$script_name" ]; then
        echo "  ./$(basename "$0") <options>"
    else
        echo "  ./$script_name <options>"
    fi
    echo
    items+="help Show help options"
    # get the longest arg length
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

    # Print the help
    (while read -r item; do
        local real_item=""
        if [ -z "$(echo "$item" | grep "^#")" ]; then
            for var in $item; do
                real_item+="$var "
                if [ "$real_item" = "$var " ]; then
                    real_item="  --$real_item"
                    local length="${#var}"
                    length=$((max_length-length))
                    real_item+="$(printf "%-${length}s" " ")"
                fi
            done
        else
            real_item+="$(printf "%-$((max_length+5))s" " ")"
            real_item+="  $(echo "$item" | sed -e "s~^#[[:space:]]*~~")"
        fi
        echo "$real_item"
    done <<< "$items")
    echo
    exit 0
}

help_menu=""
options=""

function opt() {
    local opt="$1"; shift
    local desc="$1"; shift
    options+="${opt}${nl}"
    help_menu+="${opt%%:*} ${desc}${nl}"
}

function parse_args() {
    while [ "$#" -gt "0" ]; do
        arg="$1"; shift
        if [ "$arg" = "--help" ] || [ "$arg" = "-help" ]; then
            usage "$help_menu"
        fi
    done
}

# if stdin is not a tty: read variables from pipe into args
if [ ! -t 0 ]; then
    while read var; do
        set -- "$@" "$var"
    done
fi
