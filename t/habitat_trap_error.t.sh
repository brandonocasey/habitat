#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_trap_error"


function setup() {
  stub 'habitat_cleanup'
}
function clean() {
  restore 'habitat_cleanup'
}

#
#
#
setup
test_name "Default return code when nothing passed in"
$func
code="$?"
assert "echo '$code'" "5"

test_name "habitat_cleanup called with default return code"
assert "stub_called_times 'habitat_cleanup'" "1"
clean

#
#
#
setup
test_name "Default return code with only lineno"
$func '11'
code="$?"
assert "echo '$code'" "5"

test_name "habitat_cleanup called with only lineno"
assert "stub_called_times 'habitat_cleanup'" "1"
clean

#
#
#
setup
test_name "Default return code with lineno/message"
$func '11' 'message'
code="$?"
assert "echo '$code'" "5"

test_name "habitat_cleanup called with lineno/message"
assert "stub_called_times 'habitat_cleanup'" "1"
clean

#
#
#
setup
test_name "return code is what was set with lineno/message/code"
$func '11' 'message' '2'
code="$?"
assert "echo '$code'" "2"

test_name "habitat_cleanup called with lineno/message/code"
assert "stub_called_times 'habitat_cleanup'" "1"
clean

assert_end "$func"
