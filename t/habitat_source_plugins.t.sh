#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"


function setup() {
  stub 'habitat_source_file'
}
function clean() {
  restore 'habitat_source_file'
}

setup
  scenario_name "No Args"
  dir=""
  plugin_list=""
  expected_code="1"
  source_called_times="0"
  habitat_source_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_source_file called $source_called_times times"
  assert "stub_called_times 'habitat_source_file'" "$source_called_times"
clean

setup
  scenario_name "One Arg"
  dir="$tmp"
  plugin_list=""
  expected_code="1"
  source_called_times="0"
  habitat_source_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_source_file called $source_called_times times"
  assert "stub_called_times 'habitat_source_file'" "$source_called_times"
clean

setup
  scenario_name "Two Args One Plugin"
  dir="$tmp"
  plugin_list="author/repo"
  expected_code="0"
  source_called_times="1"
  habitat_source_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_source_file called $source_called_times times"
  assert "stub_called_times 'habitat_source_file'" "$source_called_times"
clean

setup
  scenario_name "Two Args One Plugin with blank newlines"
  dir="$tmp"
  plugin_list="
author/repo
"
  expected_code="0"
  source_called_times="1"
  habitat_source_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_source_file called $source_called_times times"
  assert "stub_called_times 'habitat_source_file'" "$source_called_times"
clean


setup
  scenario_name "Two Args Two Plugin"
  dir="$tmp"
  plugin_list="author/repo
no/no"
  expected_code="0"
  source_called_times="2"
  habitat_source_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_source_file called $source_called_times times"
  assert "stub_called_times 'habitat_source_file'" "$source_called_times"
clean


setup
  scenario_name "Two Args One Plugin Source fails"
  restore 'habitat_error'
  stub 'habitat_error'

  restore "habitat_source_file"
  stub_and_eval 'habitat_source_file' "return 1"
  dir="$tmp"
  plugin_list="author/repo"
  expected_code="0"
  source_called_times="1"
  habitat_source_plugins "$dir" "$plugin_list"
  code="$?"

  test_name "Function Result Code $expected_code"
  assert "echo '$code'" "$expected_code"

  test_name "habitat_source_file called $source_called_times times"
  assert "stub_called_times 'habitat_source_file'" "$source_called_times"

  test_name "habitat_error called 1 times"
  assert "stub_called_times 'habitat_error'" "1"

clean


assert_end "habitat_source_plugins"
