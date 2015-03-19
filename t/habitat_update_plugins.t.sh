#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_update_plugins"

function setup() {
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
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}


#
#
#
setup
test_name 'TODO - Failure'
assert_raises "return 0" "1"
clean

assert_end "$func"
