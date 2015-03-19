#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_clone_plugin_repo"

function setup() {
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  stub "habitat_is_valid_plugin_name"
  stub "git"
}
function clean() {
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  restore "habitat_is_valid_plugin_name"
  restore "git"
}


#
#
#
setup
test_name 'No Args'
assert_raises "$func" "1"

test_name 'one Args'
assert_raises "$func '$tmp'" "1"

restore "habitat_is_valid_plugin_name"
stub_and_eval 'habitat_is_valid_plugin_name' 'return 1'
test_name 'two args invalid plugin'
assert_raises "$func '$tmp' 'plugin'" "1"

clean

#
#
#
setup
mkdir -p "$tmp/plugin/name"
test_name 'Clone to Existing Folder'
assert_raises "$func '$tmp' 'plugin/name'" "1"
clean

#
#
#
setup
restore "git"
stub_and_eval "git" "return 1"
test_name 'Clone Git Failure'
assert_raises "$func '$tmp' 'plugin/name'" "1"
clean

#
#
#
setup
restore "git"
stub_and_eval "git" "mkdir -p '$tmp/plugin/name'"
test_name 'Clone no habit file'
assert_raises "$func '$tmp' 'plugin/name'" "1"
clean

#
#
#
setup
restore "git"
stub_and_eval "git" "mkdir -p '$tmp/plugin/name' && touch '$tmp/plugin/name/habit'"
test_name 'Clone Success'
assert_raises "$func '$tmp' 'plugin/name'" "1"
clean





assert_end "$func"
