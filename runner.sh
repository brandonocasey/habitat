#! /bin/sh
# Run all of the unit tests, and make sure the assert/stub environment is ready to go
# implement getopts
# subset, search, etc

download() {
    name="$1"; shift;
    url="$1"; shift;
    if command -v wget > /dev/null; then
        wget -O "$name" "$url" -q --no-check-certificate
    elif command -v curl > /dev/null; then
        curl -o "$name" "$url" -q
    else
        echo "We require curl or wget to download scripts"
        exit
    fi
}


t_dir="$( cd "$( dirname "$0" )" && pwd )"
dot_dir="$( cd "$( dirname "$t_dir" )" && pwd )"
test_dir="$t_dir/tests"
tmp_dir="$t_dir"/tmp

assert_script="$t_dir/assert.sh"
stub_script="$t_dir/stub.sh"
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
    # Cleanup
    if [ ! -d "$tmp_dir" ]; then
        mkdir -p "$tmp_dir"
    fi
    rm -rf "$tmp_dir"/*

    # What file does this file test?

    # get the path without test directory appended or the final file
    file_path="$(echo "$( dirname "$FILE")" | sed -e "s~$test_dir/~~")"
    # add the final file back without an extensipn
    file_path+="/$(basename "${FILE%.*}")"

    source_file=""

    # search for the file the user wants to source
    search="$dot_dir/$file_path"
    while [ -z "$source_file" ] && [ "$search" != "$dot_dir" ]; do
        # exapnd .* if possible
        search_file="$( echo "$search".* )"

        # if expanded whe know what they want to source
        if [ "$search_file" != "$search.*" ]; then
            source_file="$search_file"
        fi
        search="$(dirname "$search")"
    done
    if [ -n "$source_file" ]; then
        echo "*** Running Test $file_path ***"
        (source "$source_file"; source "$FILE"; assert_end "$file_path";)
        echo
    else
        echo "$file_path skipped, we could not find a file to source for it"
    fi
done
