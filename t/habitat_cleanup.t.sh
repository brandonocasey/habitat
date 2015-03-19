#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_cleanup"


function setup() {
  stub 'habitat_unset_function'
  stub 'habitat_unset_variable'
  stub 'trap'
  $func
}
function clean() {
  restore 'habitat_unset_function'
  restore 'habitat_unset_variable'
  restore 'trap'
}


setup
test_name "habitat_unset_function is called"
assert_raises "stub_called 'habitat_unset_function'" "0"

test_name "habitat_unset_variable is called"
assert_raises "stub_called 'habitat_unset_variable'" "0"

# now we have the functions/variables that will be unset every time
function_start="$(stub_called_times "habitat_unset_function")"
variable_start="$(stub_called_times "habitat_unset_variable")"
clean





setup
test_name "habitat_unset_function has the same number of calls each time"
assert "stub_called_times 'habitat_unset_function'" "$function_start"

test_name "habitat_unset_variable has the same number of calls each time"
assert "stub_called_times 'habitat_unset_variable'" "$variable_start"
clean

setup
# make sure habitat_base is not unset
habitat_base="things"
test_name "habitat_unset_variable has the same number even when habitat_base is added"
assert "stub_called_times 'habitat_unset_variable'" "$variable_start"
clean





habitat_unset_me_one() {
  :
}
habitat_var_unset_me_one=""
setup
test_name "habitat_unset_function has one more call if another function is added"
assert "stub_called_times 'habitat_unset_function'" "$((function_start+1))"

test_name "habitat_unset_variable has one more call if another variable is added"
assert "stub_called_times 'habitat_unset_variable'" "$((variable_start+1))"
unset -f habitat_unset_me_one
unset habitat_var_unset_me_one
clean


#
#
# Make sure we cleanup an up two extra function/variable
#
#
habitat_unset_me_two() {
  :
}
habitat_unset_me_three() {
  :
}
habitat_var_unset_me_two=""
habitat_var_unset_me_three=""
setup
test_name "habitat_unset_function has two more calls if two functions are added"
assert "stub_called_times 'habitat_unset_function'" "$((function_start+2))"

test_name "habitat_unset_function has two more calls if two functions are added"
assert "stub_called_times 'habitat_unset_variable'" "$((variable_start+2))"
unset -f habitat_unset_me_two
unset -f habitat_unset_me_three
unset habitat_var_unset_me_two
unset habitat_var_unset_me_three
clean



assert_end "$func"
