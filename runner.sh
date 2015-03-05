#! /usr/bin/env bash
# Run all of the unit tests, and make sure the assert/stub environment is ready to go
# implement getopts
# subset, search, etc
script_dir="$( cd "$( dirname "$0" )" && pwd )"
unit_test_dir="$script_dir/t"
assert_script="$script_dir/assert.sh"
stub_script="$script_dir/stub.sh"
habitat_cli="$script_dir/habitat"
tmp="/tmp/habitat_unit_tests"


if [ ! -f "$assert_script" ] || [ ! -f "$stub_script" ]; then
    wget "https://raw.githubusercontent.com/lehmannro/assert.sh/master/assert.sh" "$assert_script"
    wget  "https://raw.githubusercontent.com/jimeh/stub.sh/master/stub.sh" "$stub_script"
fi

for unit_test_file in "$(find "$unit_test_dir" -name "*.t")"; do
    unit_test="$(basename "$unit_test_file")"
    echo "*** Running Test $unit_test ***"

    (
        # trace ERR through pipes
        #set -o pipefail
        # trace ERR through 'time command' and other functions
        #set -o errtrace
        ## set -u : exit the script if you try to use an uninitialised variable
        #set -o nounset
        ## set -e : exit the script if any statement returns a non-true return value
        #set -o errexit
        # run in posix mode
        #set -o posix

        source "$assert_script"
        source "$stub_script"
        stub unset
        source "$habitat_cli" 2>&1 > /dev/null
        source "$unit_test_file"
        assert_end "$unit_test"
    )
done
