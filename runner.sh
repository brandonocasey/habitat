#! /bin/sh
# Run all of the unit tests, and make sure the assert/stub environment is ready to go
# implement getopts
# subset, search, etc


script_dir="$( cd "$( dirname "$0" )" && pwd )"
test_dir="$script_dir/t"
tmp_dir="$script_dir/storage/tmp"
test_tmp_dir="$script_dir/storage/tmp/test"

assert_script="$tmp_dir/assert.sh"
stub_script="$tmp_dir/stub.sh"


if [ ! -f "$assert_script" ] || [ ! -f "$stub_script" ]; then
    download.sh "https://raw.githubusercontent.com/lehmannro/assert.sh/master/assert.sh" "$assert_script"
    # https://raw.githubusercontent.com/jimeh/stub.sh/master/stub.sh
    download.sh  "https://raw.githubusercontent.com/BrandonOCasey/stub.sh/master/stub.sh" "$stub_script"
fi

unset -f download

subset=()

for i in $(find "$test_dir" -not -path '../bin' -name '*.t'); do
    match="0"
    if [ "$#" -gt "0" ]; then
        match="1"
        for subset_match in "$@"; do
            if [ -n "$(echo "$i" | grep "$subset_match")" ]; then
                match="0"
            fi
        done
    fi
    if [ "$match" -eq "0" ]; then
        subset+=("$i")
    fi
done


for FILE in "${subset[@]}"; do
    if [ -d "$test_tmp_dir" ]; then
        rm -rf "$test_tmp_dir"
    fi
    mkdir -p "$test_tmp_dir"

    file_path="$( echo "$(dirname "$FILE")" | sed -e "s~$test_dir/~~" )"
    file="$(basename "${FILE%.*}")"
    script_file="$( echo "$script_dir/$file_path/$file."* )"
    if [ -f "$script_file" ]; then
        echo "*** Running Test $file_path/$file ***"
        (
            source "$stub_script"
            source "$assert_script"
            if [ -f "$(dirname "$FILE")/base" ]; then
                source "$(dirname "$FILE")/base" "$script_file"
            fi
            source "$FILE" "$script_file"
            assert_end "$file_path/$file"
        )
        echo
    else
        echo "$FILE does not have a script file at $script_file"
    fi
done
