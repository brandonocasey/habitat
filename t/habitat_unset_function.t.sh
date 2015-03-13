#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_unset_function"


function setup() {
  if [ -n "${1:-}" ]; then
    eval "function $1() {
      :
    }"
  fi
}
function clean() {
  :
}

#
#
#
setup
test_name "No Argument"
assert_raises "$func" '1'
clean

#
#
#
setup
test_name "Empty Argument"
assert_raises "$func ''" '1'
clean


#
#
#
setup
test_name "Non-Existant function to unset"
assert_raises "$func '$tmp/nope'" '1'
clean

#
#
#
setup 'function_name'
test_name "Unset Existing Function - Success"
assert_raises "$func 'function_name'" '0'

test_name "Existing Function is unset"
assert_raises "type -t 'function_name'" '0'

clean


assert_end "$func"
