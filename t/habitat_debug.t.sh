#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_debug"
restore "$func"


test_name "Blank input does nothing with debug off"
assert_raises "$func '' '' ''" "0"

test_name "Blank input prints nothing with debug off"
assert "$func '' ''"

test_name "input with debug off prints nothing"
assert "$func 'hello'"

test_name "input with debug off is successful"
assert_raises "$func 'hello'" "0"

# with debug on
habitat_debug_output=1
test_name "input with debug on prints"
assert "$func 'hello'" "Debug: hello"

test_name "input with debug is successful"
assert_raises "$func 'hello'" "0"

test_name "input with multi line input and debug is prints"
assert "$func 'hello' 'hello'" "Debug: hello\nDebug: hello"

test_name "Blank input with debug does nothing"
assert "$func '' ''"

assert_end "$func"
