#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_source_file"


function setup() {
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  while [ $# -gt 0 ]; do
    if [ -z "${1:-}" ]; then
      continue
    fi
    local file="$1"; shift
    local content=""

    if [ -n "${1:-}" ]; then
      content="$1"
    fi
    echo "$content" > "$tmp/$file"
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
test_name "No Argument for file to source"
assert_raises "$func" '1'
clean

#
#
#
setup
test_name "Empty Argument for file to source"
assert_raises "$func ''" '1'
clean


#
#
#
setup
test_name "Non-Existant file to source"
assert_raises "$func '$tmp/nope'" '1'
clean

#
#
#
setup 'exists'
test_name "Source Existing File"
assert_raises "$func '$tmp/exists'" '0'
clean

#
#
#
setup 'exists' "echo 'hello'"
test_name "Source Existing File containg an echo"
assert "$func '$tmp/exists'" 'hello'
clean

assert_end "$func"
