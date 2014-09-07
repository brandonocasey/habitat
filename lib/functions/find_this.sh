#! /bin/sh

extension=$1; shift
dir=$1; shift
exclude=()

while [ "$#" -gt "0" ]; do
    exclude+=("$1"); shift
done

# http://unix.stackexchange.com/questions/29509/transform-an-array-into-arguments-of-a-command
if [ ${#exclude[@]} -ne 0  ]; then
    find "$dir" -not -type l -name "$extension" ${exclude[@]/#/-not -path }
else
    find "$dir" -not -type l -name "$extension"
fi
