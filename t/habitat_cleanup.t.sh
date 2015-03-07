#!/usr/bin/env bash
source "test-helper.sh" "$0"
func="habitat_cleanup"


function setup() {
  stub 'habitat_unset_function'
  stub 'habitat_unset_variable'
  $func
  assert "echo '$?'" "0"
}
function clean() {
  restore 'habitat_unset_function'
  restore 'habitat_unset_variable'
}


#
#
# Make sure we cleanup habitat_
#
#
setup
# check if the number doubled
assert_raises "stub_called 'habitat_unset_function'" "0"
assert_raises "stub_called 'habitat_unset_variable'" "0"

# now we have the functions/variables that will be unset every time
function_start="$(stub_called_times "habitat_unset_function")"
variable_start="$(stub_called_times "habitat_unset_variable")"
clean





#
#
# Make sure we cleanup the same amount twice
#
#
setup
assert "stub_called_times 'habitat_unset_function'" "$function_start"
assert "stub_called_times 'habitat_unset_variable'" "$variable_start"
clean




#
#
# Make sure we cleanup an extra function/variable
#
#
habitat_unset_me_one() {
  :
}
habitat_var_unset_me_one=""
setup
assert "stub_called_times 'habitat_unset_function'" "$((function_start+1))"
assert "stub_called_times 'habitat_unset_variable'" "$((variable_start+1))"
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
assert "stub_called_times 'habitat_unset_function'" "$((function_start+3))"
assert "stub_called_times 'habitat_unset_variable'" "$((variable_start+3))"
clean



assert_end "$func"
