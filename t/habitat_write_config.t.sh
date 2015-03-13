#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_write_config"
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

test_name "Config/Key/Val added"
assert "cat '$config'" "key=val"
clean


#
#
#
setup "key" "val2"
test_name "Change Exisiting key value - Success"
assert_raises "$func '$config' 'key' 'val'" "0"

test_name "Existing key value has changed - Success"
assert "cat '$config'" "key=val"
clean


#
#
#
setup "key"
test_name "Change key with no previous value - Success"
assert_raises "$func '$config' 'key' 'val'" "0"

test_name "Existing key now has value - Success"
assert "cat '$config'" "key=val"
clean


#
#
#
setup "key" "things"
test_name "Change key with previous value to none- Success"
assert_raises "$func '$config' 'key' " "0"

test_name "Existing key now has value - Success"
assert "cat '$config'" "key="
clean

#
#
#
setup "things" "hello" "things2" "goodbye"
test_name "add key with other existing keys- Success"
assert_raises "$func '$config' 'key' 'val'" "0"

test_name "Existing key now has value - Success"
assert "cat '$config'" "things=hello\nthings2=goodbye\nkey=val"
clean







assert_end "$func"
