#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_error"
restore "$func"

test_name "Blank input is successful"
assert_raises "$func '' '' ''" "0"

test_name "Blank input prints nothing"
assert "$func '' ''" ""

test_name "input prints to stderr"
assert "$func 'hello' 2>&1" 'Error: hello'

test_name "input doesnt print to stdout"
assert "$func 'hello'" ''

test_name "input is successful"
assert_raises "$func 'hello'" "0"

test_name "multiline input prints to stderr"
assert "$func 'hello' 'hello2' 2>&1" "Error: hello\nError: hello2"

test_name "multiline input doesnt print to stdout"
assert "$func 'hello' 'hello2'" ''

test_name "multiline input is successful"
assert_raises "$func 'hello' 'hello2'" "0"

assert_end "$func"
