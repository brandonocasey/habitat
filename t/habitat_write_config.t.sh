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
clean



assert_end "$func"
