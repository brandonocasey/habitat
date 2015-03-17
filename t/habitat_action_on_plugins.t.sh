#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_action_on_plugins"

function setup() {
  stub 'habitat_is_valid_plugin_name'
  stub 'habitat_write_config'
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  while [ $# -gt 0 ]; do
    local author="${1:-}"; shift
    local plugin="${1:-}"; shift
    if [ -z "${author:-}" ]; then
      continue
    fi
    if [ ! -d "$tmp/$author" ]; then
      mkdir -p "$tmp/$author"
    fi

    if [ -z "${plugin:-}" ]; then
      continue
    fi
    if [ ! -f "$tmp/$author/$plugin" ];then
      touch "$tmp/$author/$plugin"
    fi
  done
}
function clean() {
  restore 'habitat_is_valid_plugin_name'
  restore 'habitat_write_config'
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}

#
# arguments
#
setup
test_name "No Args - Failure"
assert_raises "$func ''" "1"
clean

setup "author" "plugin"
test_name "No Action - Failure"
assert_raises "$func '' '$tmp' '1' 'author/plugin'" "1"

test_name "Invalid Action - Failure"
assert_raises "$func 'cows' '$tmp' '1' 'author/plugin'" "1"

test_name "Invalid repo dir - Failure"
assert_raises "$func 'rm' 'harr' '1' 'author/plugin'" "1"

test_name "Empty repo dir - Failure"
assert_raises "$func 'rm' '' '1' 'author/plugin'" "1"

test_name "Empty save to config - Success"
assert_raises "$func 'rm' '$tmp' '1' 'author/plugin'" "0"

test_name "Empty plugin - Success"
assert_raises "$func 'rm' '$tmp' '1' 'author/plugin'" "1"

clean


assert_end "$func"
