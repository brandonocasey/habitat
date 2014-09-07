#! /bin/sh
if [ "$#" -ne "1" ]; then
    echo 'Usage:'
    echo "  fullpath <dir>"
    echo
    echo "Example:"
    echo "  fullpath './test.sh'"
    echo
    exit 2
fi

echo "$( cd "$( dirname "$1" )" && pwd )/$(basename "$1")"
