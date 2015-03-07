#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_debug"
restore "$func"

test_name "Debug OFF: Blank input is successful"
assert_raises "$func ''" "0"

test_name "Debug OFF: Blank input doesn't print"
assert "$func ''" ""

test_name "Debug OFF: Blank multiline is successful"
assert_raises "$func '' ''" "0"

test_name "Debug OFF: Blank multiline doesn't print"
assert "$func '' ''" ""

test_name "Debug OFF: input doesn't print"
assert "$func 'hello'" ""

test_name "Debug OFF: input is successful"
assert_raises "$func 'hello'" "0"

test_name "Debug OFF: multiline input doesn't print"
assert "$func 'hello' 'hello2'" ""

test_name "Debug OFF: multiline input is successful"
assert_raises "$func 'hello' 'hello2'" "0"


# with debug on
habitat_debug_output=1
test_name "Debug ON: Blank input is successful"
assert_raises "$func ''" "0"

test_name "Debug ON: Blank input doesn't print"
assert "$func ''" ""

test_name "Debug ON: Blank multiline is successful"
assert_raises "$func '' ''" "0"

test_name "Debug ON: Blank multiline doesn't print"
assert "$func '' ''" ""

test_name "Debug ON: input prints"
assert "$func 'hello'" "Debug: hello"

test_name "Debug ON: input is successful"
assert_raises "$func 'hello'" "0"

test_name "Debug ON: multiline input prints"
assert "$func 'hello' 'hello2'" "Debug: hello\nDebug: hello2"

test_name "Debug OFF: multiline input is successful"
assert_raises "$func 'hello' 'hello2'" "0"

assert_end "$func"
