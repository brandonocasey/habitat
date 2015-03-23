#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"

function setup() {
  stub "habitat_is_valid_plugin_name"
  ls "$tmp"
}
function clean() {
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  restore "habitat_is_valid_plugin_name"
}

# no args
setup
  scenario_name "No Args"
  dir=""
  plugin=""
  expected_code="1"
  valid_called_times="0"
  habitat_stub_plugin "$dir" "$plugin"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_is_valid_plugin_name called $valid_called_times times"
  assert "stub_called_times 'habitat_is_valid_plugin_name'" "$valid_called_times"
clean

# one arg
setup
  scenario_name "One Arg"
  dir="$tmp"
  plugin=""
  expected_code="1"
  valid_called_times="0"
  habitat_stub_plugin "$dir" "$plugin"
  code="$?"
  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_is_valid_plugin_name called $valid_called_times times"
  assert "stub_called_times 'habitat_is_valid_plugin_name'" "$valid_called_times"
clean

# both args success
setup
  scenario_name "Two Valid Args"
  dir="$tmp"
  plugin="nope/nope"
  expected_code="0"
  valid_called_times="1"
  output=""
  test_name "Verify stdout"
  assert "habitat_stub_plugin '$dir' '$plugin'" "Successfully stubbed plugin nope/nope"
  if [ -d "$dir" ]; then
    rm -rf "$dir"/*
  fi
  restore 'habitat_is_valid_plugin_name'
  stub 'habitat_is_valid_plugin_name'
  habitat_stub_plugin "$dir" "$plugin"
  code="$?"
  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_is_valid_plugin_name called $valid_called_times times"
  assert "stub_called_times 'habitat_is_valid_plugin_name'" "$valid_called_times"

  test_name "Verify that the new plugin file exists"
  assert_raises "test -f '$tmp/$plugin/habit'" "0"
clean

# both args but plugin exists - Failure
setup
  scenario_name "Two Valid Args with existing Plugin"
  mkdir -p "$tmp/nope/nope"
  touch "$tmp/nope/nope/habit"

  dir="$tmp"
  plugin="nope/nope"
  expected_code="1"
  valid_called_times="1"
  habitat_stub_plugin "$dir" "$plugin"
  code="$?"
  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_is_valid_plugin_name called $valid_called_times times"
  assert "stub_called_times 'habitat_is_valid_plugin_name'" "$valid_called_times"
clean

# both args but plugin is invalid
setup
  scenario_name "Two Valid Args with invalid Plugin Name"
  restore 'habitat_is_valid_plugin_name'
  stub_and_eval 'habitat_is_valid_plugin_name' "return 1"
  dir="$tmp"
  plugin="nope/"
  expected_code="1"
  valid_called_times="1"
  habitat_stub_plugin "$dir" "$plugin"
  code="$?"
  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_is_valid_plugin_name called $valid_called_times times"
  assert "stub_called_times 'habitat_is_valid_plugin_name'" "$valid_called_times"
clean


assert_end "habitat_stub_plugin"
