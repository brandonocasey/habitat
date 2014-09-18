#! /bin/sh

#split on |
#<question>
#<default>
#<other>

function usage() {
    echo
    echo "    ./$(basename "$0")"
    echo
    echo '    '
    echo
    echo '    <url>            the url of the file you want to download'
    echo '    <save_location>  the location to save the file'
    echo
    exit 2
}
