#! /bin/sh

function info() {
    # Open a new file descriptor that redirects to stdout
    # Allowing us to print to stdout in a function
    exec 3>&1

    for var in "$@"; do
        echo "$var" 1>&3
    done

    # Close our file descriptor
    exec 3>&-
}
