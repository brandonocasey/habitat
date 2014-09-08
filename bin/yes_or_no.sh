#! /bin/sh

if [ "$#" -ne "1" ] || [ -z "$1" ]; then
    echo "Question must be defined for ask_user"
    exit 2
fi
answer="not_set"
question="$1 [y/n]"

# Open a new file descriptor that redirects to stdout
# Allowing us to print to stdout in a function
exec 3>&1

while [ -n "$(echo "$answer" | grep -E -i '^(y|n|yes|no|\n)$')" ]; do
    echo "$question" 1>&3
    read -e answer
    if [ "$?" == "0" ] && [ "$answer" == "" ];then
        answer="n"
    fi
done

# Close our file descriptor
exec 3>&-


if [ -n "$(echo "$answer" | grep -E -i "^(y|yes)$")" ]; then
    exit 0
fi
exit 1
