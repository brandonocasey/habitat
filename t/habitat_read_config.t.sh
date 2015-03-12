#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_read_config"
config="$tmp/things.cfg"


function setup() {
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  while [ $# -gt 0 ]; do
    local result=""
    if [ -n "$1" ]; then
      result="$1="; shift
    fi
    if [ -n "$1" ]; then
      result="${result}${1}"; shift
    fi
    echo "$result" >> "$config"
  done
}
function clean() {
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}

#
#
#
setup
test_name "Config not passed - Failure"
assert_raises "$func" "1"

test_name "Key not passed - Failure"
assert_raises "$func '$config'" "1"
clean


#
#
#
setup
test_name "No Config - Success"
assert_raises "$func '$config' 'sucks'" "0"

test_name "No Config - No Output"
assert "$func '$config' 'sucks'" ""

test_name "Config Created?"
assert_raises "test -f '$config'" "0"
clean

#
#
#
setup
touch "$config"
test_name "Config no keys - Success"
assert_raises "$func '$config' 'sucks'" "0"

test_name "Config no keys - No Output"
assert "$func '$config' 'sucks'" ""
clean

#
#
#
setup "suc" "value"
test_name "Config not the key we want - Success"
assert_raises "$func '$config' 'sucks'" "0"

test_name "Config not the key we want - No Output"
assert "$func '$config' 'sucks'" ""
clean

#
#
#
setup "sucks"
test_name "Config key we want no value - Success"
assert_raises "$func '$config' 'sucks'" "0"

test_name "Config key we want no value - No Output"
assert "$func '$config' 'sucks'" ""
clean

#
#
#
setup "sucks" "stuff"
test_name "Config key we want with value - Success"
assert_raises "$func '$config' 'sucks'" "0"

test_name "Config key we want with value - Output"
assert "$func '$config' 'sucks'" "stuff"
clean





assert_end "$func"
