#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_verify_requirements"

function setup() {
  stub "command"
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  unset HOME
  unset habitat_base
}
function clean() {
  restore "command"
  unset HOME
  unset habitat_base
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}


#
#
#
setup
restore 'command'
stub_and_eval "command" "return 1"
test_name 'No Git Installed'
assert_raises "$func" "1"
clean

setup
test_name 'No Home or habitat_base'
assert_raises "$func" "1"
clean

setup
HOME="$tmp"
test_name 'Home set but no habitat cli'
$func
code="$?"
assert "echo '$code'" "1"
clean

setup
habitat_base="$tmp"

test_name 'habitat_base set but no habitat cli'
$func
code="$?"
assert "echo '$code'" "1"
clean

setup
HOME="$tmp"
mkdir -p "$tmp/.habitat"
touch "$tmp/.habitat/habitat"
test_name 'Home with habitat cli existing'
$func
code="$?"
assert "echo '$code'" "0"

test_name "Verify that habitat_base was set to home"
assert_raises "test '$habitat_base' = '$HOME/.habitat'" "0"
clean

setup
HOME="$tmp"
mkdir -p "$tmp/.habitat"
touch "$tmp/.habitat/habitat"
habitat_base="$tmp/thing"

$func
code="$?"
test_name "home with cli habitat_base without"
assert "echo '$code'" "0"

test_name "Verify that habitat_base was set to home"
assert_raises "test '$habitat_base' = '$HOME/.habitat'" "0"
clean

setup
mkdir -p "$tmp/.habitat"
touch "$tmp/.habitat/habitat"
habitat_base="$tmp/.habitat"

test_name 'habitat_base with cli'
assert_raises "$func" "0"
clean






assert_end "$func"
