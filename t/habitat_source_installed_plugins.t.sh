#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_source_installed_plugins"


function setup() {
  stub 'habitat_source'
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
  restore 'habitat_source'
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}

setup
test_name "No Authors/Plugins - No STDOUT"
assert "$func '$tmp'" ""

test_name "No Authors/Plugins - Failure"
assert_raises "$func '$tmp'" "1"

test_name "No Authors/Plugins - source not called"
assert "stub_called_times 'habitat_source'" "0"
clean



setup "author"
test_name "1 Authors 0 Plugins - No STDOUT"
assert "$func '$tmp'" ""

test_name "1 Authors 0 Plugins - Success"
assert_raises "$func '$tmp'" "0"

test_name "1 Authors 0 Plugins - source not called"
assert "stub_called_times 'habitat_source'" "0"
clean


setup "author" "plugin"
test_name "1 Authors 1 Plugins - STDOUT"
assert "$func '$tmp'" "author_plugin"

test_name "1 Authors 1 Plugins - Success"
assert_raises "$func '$tmp'" "0"


test_name "1 Authors 1 Plugins - source not called"
assert "stub_called_times 'habitat_source'" "1"
clean


assert_end "$func"
