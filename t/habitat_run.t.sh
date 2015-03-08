#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_run"


function setup() {
  stub 'habitat_call_function'
}
function clean() {
  restore 'habitat_call_function'
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
assert "stub_called_times 'habitat_call_function'" "0"
clean


#
#
#
setup
plugins="thing/thing"
function habitat_thing_thing_setup() {
  :
}
test_name "1 plugins setup function - no output"
assert "$func '$plugins'" ""

test_name "1 plugins setup function - success"
assert_raises "$func '$plugins'" "0"

test_name "1 plugins setup function - 1 function called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "1"
unset -f habitat_thing_thing_setup
clean



#
#
#
setup
plugins="thing/thing"
function habitat_thing_thing_setup() {
  :
}
function habitat_thing_thing_run() {
  :
}

test_name "1 plugins setup/run function - no output"
assert "$func '$plugins'" ""

test_name "1 plugins setup/run function - success"
assert_raises "$func '$plugins'" "0"

test_name "1 plugins setup/run function - 2 function called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "2"
unset -f habitat_thing_thing_setup
unset -f habitat_thing_thing_run
clean


#
#
#
setup
plugins="thing/thing thing/wings"
function habitat_thing_thing_setup() {
  :
}
function habitat_thing_thing_run() {
  :
}

test_name "2 plugins 1 with setup/run function - no output"
assert "$func '$plugins'" ""

test_name "2 plugins 1 with setup/run function - success"
assert_raises "$func '$plugins'" "0"

test_name "2 plugins 1 with setup/run function - 2 function called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "2"
unset -f habitat_thing_thing_setup
unset -f habitat_thing_thing_run
clean


#
#
#
setup
plugins="thing/thing thing/wings"
function habitat_thing_thing_setup() {
  :
}
function habitat_thing_thing_run() {
  :
}

function habitat_thing_wings_setup() {
  :
}
function habitat_thing_wings_run() {
  :
}

test_name "2 plugins both with setup/run function - no output"
assert "$func '$plugins'" ""

test_name "2 plugins both with setup/run function - success"
assert_raises "$func '$plugins'" "0"

test_name "2 plugins both with setup/run function - 4 function called"
$func "$plugins" 2>&1 > /dev/null
assert "stub_called_times 'habitat_call_function'" "4"
unset -f habitat_thing_thing_setup
unset -f habitat_thing_thing_run
clean






assert_end "$func"
