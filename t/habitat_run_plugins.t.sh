#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"


function setup() {
  stub 'habitat_call_function'
}
function clean() {
  restore 'habitat_call_function'
}

setup
  scenario_name "No Args"
  dir=""
  plugin_list=""
  expected_code="1"
  call_function_called_times="0"
  habitat_run_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_call_function called $call_function_called_times times"
  assert "stub_called_times 'habitat_call_function'" "$call_function_called_times"
clean

setup
  scenario_name "One Arg"
  dir="$tmp"
  plugin_list=""
  expected_code="1"
  call_function_called_times="0"
  habitat_run_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_call_function called $call_function_called_times times"
  assert "stub_called_times 'habitat_call_function'" "$call_function_called_times"
clean


setup
  scenario_name "Two Valid Args One Plugin"
  dir="$tmp"
  plugin_list="one/one"
  expected_code="0"
  call_function_called_times="1"
  habitat_run_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_call_function called $call_function_called_times times"
  assert "stub_called_times 'habitat_call_function'" "$call_function_called_times"
clean

setup
  scenario_name "Two Valid Args Two Plugin"
  dir="$tmp"
  plugin_list="one/one
two/two"
  expected_code="0"
  call_function_called_times="2"
  habitat_run_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_call_function called $call_function_called_times times"
  assert "stub_called_times 'habitat_call_function'" "$call_function_called_times"
clean

setup
  scenario_name "Two Valid Args One Plugin Call Failure"
  restore "habitat_call_function"
  stub_and_eval "habitat_call_function" "return 1"
  restore "habitat_error"
  stub "habitat_error"
  dir="$tmp"
  plugin_list="one/one"
  expected_code="0"
  call_function_called_times="1"
  habitat_run_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_call_function called $call_function_called_times times"
  assert "stub_called_times 'habitat_call_function'" "$call_function_called_times"

  test_name "habitat_error called 1 time"
  assert "stub_called_times 'habitat_error'" "1"
clean



assert_end "$func"
