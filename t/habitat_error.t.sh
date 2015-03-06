#!/usr/bin/env bash

source "test-helper.sh" "$0"
function="habitat_error"
restore "$function"

# with blank args
assert_raises "$function '' '' ''" "0"
assert "$function '' '' '' 2>&1"
assert "$function 'hello'"
assert "$function 'hello' 2>&1" "Error: hello"
assert_raises "$function 'hello'" "0"
assert_end "$function"
