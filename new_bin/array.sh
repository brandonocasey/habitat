#! /bin/sh
#
# array.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

# emulate an array
# support for hash in array?
# support for array in array?

function push() {

    echo "NYI"
}

function shift() {

    echo "NYI"
}

function pop() {
    echo "NYI"

}

function unshift() {
    echo "NYI"

}

function splice() {
    echo "NYI"

}

function index() {
    echo "NYI"
}

function all() {
    local array="$1"; shift
    (
        IFS="|"
        for value in $array; do
            echo "$value"
        done
    )
}



function length() {
    echo "NYI"
}

# return index or undef
function exists() {
    local array="$1"; shift
    local value="$1"; shift
    if [ -n "$(echo "$array" | grep -E "(^|\|)$value($|\|)")" ]; then
        return 0
    fi
    return 1
}

array="asd|dsa|ddd"

all "$array"
exists "$array" "dsa"
