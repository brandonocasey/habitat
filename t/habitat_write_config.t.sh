#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_write_config"
config="$tmp/things.cfg"

# TODO: multiple same config lines

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

test_name "Val not passed - Success"
assert_raises "$func '$config' 'key'" "0"

test_name "Config has key with no value"
assert "cat '$config'" "key="

clean

#
#
#
setup
test_name "Config/Key/Val passed success - Success"
assert_raises "$func '$config' 'key' 'val'" "0"

test_name "Config contains correct value"
assert "cat '$config'" "key=val"


test_name "Change config value"
assert_raises "$func '$config' 'key' 'val2'" "0"

test_name "Config Value was changed"
assert "cat '$config'" "key=val2"

test_name "Add config value"
assert_raises "$func '$config' 'key2' 'val2'" "0"

test_name "Config Value was added"
assert "cat '$config'" "key=val2\nkey2=val2"


clean




assert_end "$func"
