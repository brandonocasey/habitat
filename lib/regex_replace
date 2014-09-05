#! /bin/sh

function regex_replace() {
    if [ "$#" -ne "2" ] || [ -z "$1" ] || [ -z "$2" ]; then
        echo 'Usage:'
        echo "  regex_replace <string> <replace_regex>"
        echo
        echo "Example:"
        echo "  regex_replace 'derp' 's/de//'"
        echo
        return 2
    fi
    # using a seprate decleration because
    # local variable declartion as a return code so it overwrote the actual return code
    # http://stackoverflow.com/a/4764877
    local result=""
    result="$( set -o pipefail; echo "$1" | sed -e "$2")"
    if [ "$?" -ne "0" ]; then
        echo "Regex Error: $result"
        return 2
    fi

    echo "$result"
}
