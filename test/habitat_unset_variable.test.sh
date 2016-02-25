#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_unset_variable"


function setup() {
  if [ -n "${1:-}" ]; then
    local var_name="$1"; shift
    local value=""
    if [ -n "${1:-}" ]; then
      value="$1"; shift
    fi
    eval "$var_name='$value'"
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
test_name "Non-Existant variable to unset"
assert_raises "$func 'nope'" '1'
clean

#
#
#
setup 'unset_me' '11'
test_name "Existing variable with value to unset"
assert_raises "$func 'unset_me'" '0'
clean

#
#
#
setup 'unset_again'
test_name "Existing variable without value to unset"
assert_raises "$func 'unset_again'" '0'
clean


assert_end "$func"
