#! /bin/sh
#
# example_args.sh
# Copyright (C) 2014 CORPcasey <CORPcasey@Brandon-Caseys-iMac.local>
#
# Distributed under terms of the MIT license.
#

function usage() {
    echo
    echo "    ./$(basename($0))"
    echo
    echo "  -h|--help    Show this help"
    echo
}

while [ "$#" -gt "0" ]; do
    arg="$1"; shift
    case $arg in
        -h|--help)
        usage
        exit 0
        ;;
        -s|--searchpath)
        SEARCHPATH="$1"; shift
        ;;
        -l|--lib)
        LIBPATH="$1"; shift
        ;;
        --default)
        DEFAULT=YES
        ;;
        *)
            echo "Invalid Argument $arg"
            exit 2
        ;;
    esac
done
