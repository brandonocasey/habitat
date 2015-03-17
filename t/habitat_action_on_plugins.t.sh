#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_action_on_plugins"

function setup() {
  stub 'habitat_is_valid_plugin_name'
  stub 'habitat_write_config'
  stub 'habitat_add_plugin'
  stub 'habitat_rm_plugin'
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  if [ -n "${1:-}" ]; then
    mkdir -p "$tmp/$1"
  fi
}
function clean() {
  restore 'habitat_is_valid_plugin_name'
  restore 'habitat_write_config'
  restore 'habitat_add_plugin'
  restore 'habitat_rm_plugin'

  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}

#
# arguments
#
setup
test_name "0 Args - Failure"
assert_raises "$func " "1"

test_name "1 Args - Failure"
assert_raises "$func 'rm' " "1"

test_name "2 Args - Failure"
assert_raises "$func 'rm' '$tmp' " "1"

test_name "3 Args - Failure"
assert_raises "$func 'rm' '$tmp' '1'" "1"

test_name "Invalid Action - Failure"
assert_raises "$func 'cows' '$tmp' '1' 'author/plugin'" "2"

clean

#
# add
#
setup
$func 'add' "$tmp/hello" '0' 'author/plugin'
code="$?"
test_name "Add a plugin - Success"
assert "echo '$code'" '0'
test_name "Add plugin function called"
assert "stub_called_with_times habitat_add_plugin '0' '$tmp/hello' 'author/plugin'" "1"

test_name "rm a plugin - Not Called"
assert "stub_called_with_times habitat_up_plugin '0' '$tmp/hello' 'author/plugin'" "0"

test_name "validate a plugin - Called"
assert "stub_called_with_times habitat_is_valid_plugin_name 'author/plugin'" "1"

test_name "repo dir created"
assert_raises "test -d '$tmp/hello'" "0"
clean



#
# add 2
#
setup
$func 'add' "$tmp/hello" '0' 'author/plugin' 'author/plugin'
code="$?"
test_name "Add two plugins - Success"
assert "echo '$code'" '0'
test_name "Add plugin function called twice"
assert "stub_called_with_times habitat_add_plugin '0' '$tmp/hello' 'author/plugin'" "2"

test_name "rm a plugin - Not Called"
assert "stub_called_with_times habitat_up_plugin '0' '$tmp/hello' 'author/plugin'" "0"

test_name "validate a plugin - Called twice"
assert "stub_called_with_times habitat_is_valid_plugin_name 'author/plugin'" "2"

test_name "repo dir created"
assert_raises "test -d '$tmp/hello'" "0"
clean







#
# rm
#
setup
$func 'rm' "$tmp/hello" '0' 'author/plugin'
code="$?"
test_name "RM a plugin - Success"
assert "echo '$code'" '0'
test_name "Add plugin function not called"
assert "stub_called_with_times habitat_add_plugin '0' '$tmp/hello' 'author/plugin'" "0"

test_name "update a plugin - Not Called"
assert "stub_called_with_times habitat_rm_plugin '0' '$tmp/hello' 'author/plugin'" "1"

test_name "validate a plugin - Called"
assert "stub_called_with_times habitat_is_valid_plugin_name 'author/plugin'" "1"

test_name "repo dir created"
assert_raises "test -d '$tmp/hello'" "0"
clean



#
# rm 2
#
setup
$func 'rm' "$tmp/hello" '0' 'author/plugin' 'author/plugin'
code="$?"
test_name "Add two plugins - Success"
assert "echo '$code'" '0'
test_name "Add plugin function not called"
assert "stub_called_with_times habitat_add_plugin '0' '$tmp/hello' 'author/plugin'" "0"

test_name "update a plugin - Not Called"
assert "stub_called_with_times habitat_rm_plugin '0' '$tmp/hello' 'author/plugin'" "2"

test_name "validate a plugin - Called twice"
assert "stub_called_with_times habitat_is_valid_plugin_name 'author/plugin'" "2"

test_name "repo dir created"
assert_raises "test -d '$tmp/hello'" "0"
clean


assert_end "$func"
