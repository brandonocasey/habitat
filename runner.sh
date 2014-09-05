#! /bin/sh
# Run all of the unit tests, and make sure the assert/stub environment is ready to go
# implement getopts
# subset, search, etc


script_dir="$( cd "$( dirname "$0" )" && pwd )"
test_dir="$script_dir/t"
tmp_dir="$script_dir/storage/tmp"

assert_script="$t_dir/assert.sh"
stub_script="$t_dir/stub.sh"


source "$script_dir/download"
if [ ! -f "$assert_script" ]; then
    download "$assert_script" "https://raw.githubusercontent.com/lehmannro/assert.sh/master/assert.sh"
fi

if [ ! -f "$stub_script" ]; then
    # https://raw.githubusercontent.com/jimeh/stub.sh/master/stub.sh
    download "$stub_script" "https://raw.githubusercontent.com/BrandonOCasey/stub.sh/master/stub.sh"
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

echo
if [ "${#subset[@]}" -eq "0" ]; then
    for i in $(find "$test_dir" -not -path '../bin' -name '*.t'); do
        subset+=("$i")
    done
fi

for FILE in "${subset[@]}"; do
    echo "*** Running Test $file_path ***"
    (source "$FILE"; assert_end "$file_path";)
    echo
done
