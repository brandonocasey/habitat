#! /bin/sh
# Run all of the unit tests, and make sure the assert/stub environment is ready to go
# implement getopts
# subset, search, etc


script_dir="$( cd "$( dirname "$0" )" && pwd )"
test_dir="$script_dir/t"
tmp_dir="$script_dir/storage/tmp"

assert_script="/tmp/assert.sh"
stub_script="/tmp/stub.sh"


if [ ! -f "$assert_script" ] || [ ! -f "$stub_script" ]; then
    source "$script_dir/lib/functions/download.sh"
    download "https://raw.githubusercontent.com/lehmannro/assert.sh/master/assert.sh" "$assert_script"
    # https://raw.githubusercontent.com/jimeh/stub.sh/master/stub.sh
    download  "https://raw.githubusercontent.com/BrandonOCasey/stub.sh/master/stub.sh" "$stub_script"
fi

unset -f download

subset=()
while test $# -gt 0; do
    if [ -f "$1" ]; then
        subset+=("$1"); shift
    elif [ -f "$test_dir"/"$1" ]; then
        subset+=("$test_dir"/"$1"); shift
    else
        echo "$1 is not a test that we can run"
        exit
    fi
done



source "$stub_script"
source "$assert_script"

if [ "${#subset[@]}" -eq "0" ]; then
    for i in $(find "$test_dir" -not -path '../bin' -name '*.t'); do
        subset+=("$i")
    done
fi

for FILE in "${subset[@]}"; do
    rm -rf "$tmp_dir"/*
    file_path="$( echo "$(dirname "$FILE")" | sed -e "s~$test_dir/~~" )"
    file="$(basename "${FILE%.*}")"
    script_file="$( echo "$script_dir/$file_path/$file."* )"
    if [ -f "$script_file" ]; then
        echo "*** Running Test $file_path/$file ***"
        (
            source "$stub_script"
            source "$assert_script"
            source "$script_file"
            source "$FILE"
            assert_end "$file_path/$file"
        )
        echo
    else
        echo "$FILE does not have a script file at $script_file"
    fi
done
