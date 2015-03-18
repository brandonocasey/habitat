#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_rm_plugin"

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

  stub 'habitat_write_config'
  stub 'habitat_read_config'
  stub 'habitat_is_valid_plugin_name'
}
function clean() {
  restore 'habitat_write_config'
  restore 'habitat_read_config'
  restore 'habitat_is_valid_plugin_name'

  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}


#
#
#
setup
test_name 'No Args - Failure'
assert_raises "$func" "1"

test_name 'One Arg - Failure'
assert_raises "$func '1'" "1"

test_name 'Two Args - Failure'
assert_raises "$func '1' '$tmp'" "1"
restore 'habitat_is_valid_plugin_name'
stub_and_eval 'habitat_is_valid_plugin_name' 'return 1'
test_name 'Three Args Invalid plugin name - Failure'
assert_raises "$func '1' '$tmp' 'author/plugin'" "1"

clean

#
#
#
setup "author" "name" "thing" "thing"
$func '1' "$tmp" 'author/name'
code="$?"
test_name 'Remove an exisiting plugin'
assert "echo '$code'" "0"

test_name 'verify that valid plugin name was called'
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

test_name 'verify the file was deleted'
assert_raises "test -f '$tmp/author/name'" "1"

test_name 'verify that another author was not deleted'
assert_raises "test -f '$tmp/thing/thing'" "0"

test_name 'verify the author was deleted as it has no more files'
assert_raises "test -d '$tmp/author'" "1"
clean

#
# verify that the author dir is not deleted if they have more than 1 plugin
#
setup "author" "name" "author" "thing"
$func '1' "$tmp" 'author/name'
test_name 'verify that the author was not deleted'
assert_raises "test -d '$tmp/author'" "0"

test_name 'verify the authors plugin was not deleted'
assert_raises "test -f '$tmp/author/thing'" "0"

test_name 'verify that valid plugin name was called'
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean


#
#
#
setup "author" "test"
$func '1' "$tmp" 'author/name'
code="$?"
test_name 'Remove a non-existing plugin'
assert "echo '$code'" "1"

test_name 'verify the nothing was deleted'
assert_raises "test -f '$tmp/author/test'" "0"

test_name 'verify that valid plugin name was called'
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"


clean


#
#
#
setup "author" "name"
$func 'config_file.cfg' "$tmp" 'author/name'
code="$?"
test_name 'Remove an existing plugin and save to config'
assert "echo '$code'" "0"

test_name 'verify that write config was called'
assert "stub_called_times 'habitat_write_config'" "1"

test_name 'verify that valid plugin name was called'
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"


# TODO: how to capture a function call through an aubshell output capture $()
# test_name 'verify that read config was called'
# assert "stub_called_with habitat_read_config 'config_file.cfg'" "1"

clean

#
#
#
setup "author" "test"
$func 'config_file.cfg' "$tmp" 'author/name'
code="$?"
test_name 'Remove an non-existing plugin and save to config'
assert "echo '$code'" "1"

test_name 'verify that write config was still called'
assert "stub_called_times habitat_write_config" "1"

test_name 'verify that valid plugin name was called'
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"


# TODO: how to capture a function call through an aubshell output capture $()
# test_name 'verify that write read config was still called'
# assert "stub_called_times habitat_read_config" "1"

clean





assert_end "$func"
