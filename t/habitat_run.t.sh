#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_run"


function setup() {
  stub 'habitat_call_function'
  stub 'habitat_is_valid_plugin_name'
}
function clean() {
  restore 'habitat_call_function'
  restore 'habitat_is_valid_plugin_name'
}


#
#
#
setup
plugins=""
test_name "no plugins - no output"
assert "$func '$plugins'" ""

test_name "no plugins - failure"
assert_raises "$func '$plugins'" "1"

test_name "no plugins - no functions called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "0"

test_name "no plugins - no plugin name validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "0"
clean


#
#
#
setup
plugins="thing/thing"
test_name "1 plugins no functions - no output"
assert "$func '$plugins'" ""

test_name "1 plugins no functions - success"
assert_raises "$func '$plugins'" "0"

test_name "1 plugins no functions - no functions called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "1"

test_name "1 plugin - plugin name validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"
clean


#
#
#
setup
plugins="thing/thing"
test_name "1 plugins run function - no output"
assert "$func '$plugins'" ""

test_name "1 plugins run function - success"
assert_raises "$func '$plugins'" "0"

test_name "1 plugins run function - 1 function called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "1"

test_name "1 plugin - plugin name validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean



#
#
#
setup
plugins="thing/thing thing/wings"

test_name "2 plugins 1 with run function - no output"
assert "$func '$plugins'" ""

test_name "2 plugins 1 with run function - success"
assert_raises "$func '$plugins'" "0"

test_name "2 plugins 1 with run function - 2 function called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "2"

test_name "2 plugins - plugin name validation called twice"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "2"

clean


#
#
#
setup
plugins="thing/thing thing/wings"
test_name "2 plugins both with a run function - no output"
assert "$func '$plugins'" ""

test_name "2 plugins both with a run function - success"
assert_raises "$func '$plugins'" "0"

test_name "2 plugins both with a run function - 2 function called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "2"

test_name "2 plugins - plugin name validation called twice"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "2"

clean



#
#
#
setup
plugins="thing/thing"
# need to make it return false for these tests
restore 'habitat_is_valid_plugin_name'
stub_and_eval 'habitat_is_valid_plugin_name' "return 1"

test_name "1 plugins run function, invalid plugin name - no output"
assert "$func '$plugins'" ""

test_name "1 plugins run function, invalid plugin name - success"
assert_raises "$func '$plugins'" "0"

test_name "1 plugins run function, all invalid - 0 functions called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "0"

test_name "1 plugin - plugin name validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean




assert_end "$func"
