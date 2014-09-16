#! /bin/sh

function usage() {
    echo
    echo "    ./$(basename "$0") <extension> <starting_dir> <exclude> ..."
    echo
    echo '    return a list of files with a file extension'
    echo
    echo '    <extension>  extension of the files you want to find ex: .sh'
    echo '    <start_dir>  the directory to recursively start the search from'
    echo '    <excludes>   iN number of paths to exclude ex: */osx/*'
    echo
    exit 2
}
for arg in "$@"; do
    if [ -n "$(echo "$arg" | grep -E '^--?(h|help)')" ]; then
        usage
    fi
done
if [ -z "$1" ] || [ -z "$2" ]; then
    usage
fi


extension="*$1"; shift
dir="$1"; shift
found_code="1"

for file in $(find "$dir" ! -type l -name "$extension"); do
    excluded="0"
    for exclude in "$@"; do
        if [ -n "$( echo "$file" | grep "$exclude")" ]; then
            excluded="1"
        fi
    done

    if [ "$excluded" -eq "0" ]; then
        echo "$file"
        found_code="0"
    fi
done

exit "$found_code"
