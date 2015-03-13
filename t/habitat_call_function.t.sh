#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_call_function"


function setup() {
  if [ -n "${1:-}" ]; then
    eval "function $1() {
      echo '$1'
    }"
  fi
}
function clean() {
  if [ -n "${1:-}" ]; then
    unset -f "$1"
  fi
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
test_name "Non-Existant function to call"
assert_raises "$func 'nope'" '1'
clean

#
#
#
setup 'function_name'
test_name "Existing Function to call- Success"
assert_raises "$func 'function_name'" '0'
clean 'function_name'

#
#
#
setup 'function_name'
test_name "Existing Function with output -"
assert "$func 'function_name'" 'function_name'
clean 'function_name'



assert_end "$func"
