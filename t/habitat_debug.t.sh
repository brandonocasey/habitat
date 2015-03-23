#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
restore 'habitat_debug'

function setup() {
  :
}

function clean() {
  :
}

setup
  scenario_name "Debug OFF"
  test_name "Blank input return code"
  assert_raises "habitat_debug '' 2>&1" "0"

  test_name "Blank input stderr"
  assert "habitat_debug '' 2>&1" ""

  test_name "Blank multiline return code"
  assert_raises "habitat_debug '' '' 2>&1" "0"

  test_name "Blank multiline stderr"
  assert "habitat_debug '' '' 2>&1" ""

  test_name "one arg return code"
  assert_raises "habitat_debug 'hello' 2>&1 " "0"

  test_name "One Arg stderr"
  assert "habitat_debug 'hello' 2>&1" ""

  test_name "two args return code"
  assert_raises "habitat_debug 'hello' 'hello2' 2>&1" "0"

  test_name "two args stderr"
  assert "habitat_debug 'hello' 'hello2' 2>&1" ""
clean

setup
  scenario_name "Debug ON"
  habitat_debug_output="0"
  test_name "Blank input return code"
  assert_raises "habitat_debug '' 2>&1" "0"

  test_name "Blank input stderr"
  assert "habitat_debug '' 2>&1" ""

  test_name "Blank multiline return code"
  assert_raises "habitat_debug '' '' 2>&1" "0"

  test_name "Blank multiline stderr"
  assert "habitat_debug '' '' 2>&1" ""

  test_name "one arg return code"
  assert_raises "habitat_debug 'hello' 2>&1 " "0"

  test_name "One Arg stderr"
  assert "habitat_debug 'hello' 2>&1" "Debug: hello"

  test_name "two args return code"
  assert_raises "habitat_debug 'hello' 'hello2' 2>&1" "0"

  test_name "two args stderr"
  assert "habitat_debug 'hello' 'hello2' 2>&1" "Debug: hello\nDebug: hello2"
clean

assert_end "habitat_debug"
