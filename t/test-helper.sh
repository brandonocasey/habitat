test_dir="$( cd "$( dirname "$1" )" && pwd )"; shift
if [ -n "${1:-}" ]; then
    output="0"; shift
fi
if [ -n "${1:-}" ]; then
    debug="0"; shift
fi

assert_script="$test_dir/assert.sh"
stub_script="$test_dir/stub.sh"
script_under_test="$test_dir/../habitat"
tmp="/tmp/habitat_unit_tests"
habitat_debug_output=""

# clean temp files
if [ -d "$tmp" ]; then
    rm -rf "$tmp"
fi
mkdir -p "$tmp"


if [ ! -f "$assert_script" ]; then
    wget --quiet "https://raw.github.com/lehmannro/assert.sh/master/assert.sh" -P "$test_dir"
fi
if [ ! -f "$stub_script" ]; then
    wget --quiet "https://raw.github.com/jimeh/stub.sh/master/stub.sh" -P "$test_dir"
fi

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

test_index=1
function test_name() {
    if [ -n "${output:-}" ]; then
        printf "\t*** Test $test_index: $1\n"
    fi
    test_index=$((test_index+1))
}
function scenario_name() {
    if [ -n "${output:-}" ]; then
        echo "*** $1 ***"
    fi
}


habitat_unit_testing="0"

source "$assert_script"
source "$stub_script"
source "$script_under_test"
if [ -n "${debug:-}" ]; then
    stub_and_eval 'habitat_error' 'echo "Error: $@" 1>&2'
    stub_and_eval 'habitat_debug' 'echo "Debug: $@" 1>&2'
else
    stub 'habitat_error'
    stub 'habitat_debug'
fi
