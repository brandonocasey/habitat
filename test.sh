#! /bin/sh
#
# test.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

options=""
help_menu=""

function opt() {
    local opts="$1"; shift
    local desc="$1"; shift
    local definition="${opts#*:}"
    if [ "$definition" = "$opts" ]; then
        definition=""
    else
        definition=":$definition"
    fi
    options+="$(
    IFS="|"
    for opt in $opts; do
        opt="${opt%%:*}${definition}"
        if [ -z "$options" ]; then
            echo "$opt"
        else
            echo " $opt"
        fi
    done
    )"
    help_menu+="${opt%%:*} ${desc}${nl}"
}
function error() {
    echo "$1"
    exit 2
}

function validate_arg() {
    local option="$1"; shift


    local definition="${option#*:}"
    definition="${definition%%:*}"
    local old_definition="$definition"
    if [ "$definition" = "$option" ]; then
        return
    fi

    (
    IFS="-"
    for arg in
        while [ "$definition" -gt "0" ]; do
            definition=$((definition-1))
            if [ -z "$1" ]; then
                error "$option requires $old_definition args"
            fi
        done
    )
}

function parse_args() {
    while [ "$#" -gt "0" ]; do
        arg="$1"; shift
        if [ "$arg" = "--help" ] || [ "$arg" = "-help" ] || [ "$arg" = "-h" ] || [ "$arg" = "--h" ]; then
            usage "$help_menu"
        fi

        for option in $options; do
            case $arg in
                -${option%%:*}|--${option%%:*})
                ;;
            esac
        done
    done
}


opt "flarg|f:1-a"  "do the flarg"
opt "ping|p:2-a"      "do the flarg"
opt "ring|r:b"      "do the flarg"
opt "string|s:b"    "do the flarg"
parse_args "$@"
