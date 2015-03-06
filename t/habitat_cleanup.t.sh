#!/usr/bin/env bash
source "test-helper.sh" "$0"
function="habitat_cleanup"
stub 'habitat_unset_function'
stub 'habitat_unset_variable'

$function
# check if the number doubled
assert_raises "stub_called 'habitat_unset_function'" "0"
assert_raises "stub_called 'habitat_unset_variable'" "0"

# now we have the base, when
unset_function_calls="$(stub_called_times "habitat_unset_function")"
unset_variable_calls="$(stub_called_times "habitat_unset_variable")"





assert_end "$function"
