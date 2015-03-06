test_dir="$( cd "$( dirname "$1" )" && pwd )"; shift
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


 if [ ! -f "$assert_script" ] || [ ! -f "$stub_script" ]; then
     wget "https://raw.githubusercontent.com/lehmannro/assert.sh/master/assert.sh" "$assert_script"
     wget  "https://raw.githubusercontent.com/jimeh/stub.sh/master/stub.sh" "$stub_script"
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


source "$assert_script"
source "$stub_script"
source "$script_under_test" --unit_testing 2>&1 > /dev/null
