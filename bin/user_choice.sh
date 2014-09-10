#! /bin/sh

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "user_choice <question> <default> <choice> ..."
    exit 2
fi
answer="not_set"
question="$1"; shift
question+=" [$@]"

# Open a new file descriptor that redirects to stdout
# Allowing us to print to stdout in a function
exec 3>&1

found=1
while [ "$found" -ne "0" ]; do
    echo "$question" 1>&3
    read -e answer
    for i in "$@"; do
        if [ -n "$(echo "$answer" | grep -E -i "$i")" ]; then
            found="0"
        fi
    done
done

# Close our file descriptor
exec 3>&-

echo "$answer"
