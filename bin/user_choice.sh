#! /bin/sh

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "user_choice <question> <default> <choice> ..."
    exit 2
fi
answer="not_set"
question="$1 "; shift
question+="$(echo "$@" | sed -e 's~ ~, ~g')"

found=1
while [ "$found" -ne "0" ]; do
    echo "$question" 1>&2
    read -e answer
    for i in "$@"; do
        if [ -n "$(echo "$answer" | grep -E -i "$i")" ]; then
            found="0"
        fi
    done
done

echo "$answer"
