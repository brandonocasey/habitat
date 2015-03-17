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
  stub 'habitat_get_config'
  stub 'sed'
}
function clean() {
  restore 'habitat_write_config'
  restore 'habitat_get_config'
  restore 'sed'

  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}

#
# dont have to test args as we have habitat_action_on_plugins for that
#
setup "author" "name" "thing" "thing"
test_name 'Remove an exisiting plugin'

$func '1' "$tmp" 'author/name'
code="$?"
assert "echo '$code'" "0"

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

clean


#
#
#
setup "author" "name"
test_name 'Remove an existing plugin and save to config'
$func '0' "$tmp" 'author/name'

test_name 'verify that write config was called'
assert "stub_called_times habitat_write_config" "1"

test_name 'verify that write get config was called'
assert "stub_valled_times habitat_get_config" "1"

test_name 'verify that sed was called'
assert "stub_valled_times sed" "1"
clean

#
#
#
setup "author" "test"
test_name 'Remove an non-existing plugin and save to config'
assert_raises "$func '0' '$tmp' 'author/name'" "1"

test_name 'verify that write config was still called'
assert "stub_called_times habitat_write_config" "1"

test_name 'verify that write get config was still called'
assert "stub_valled_times habitat_get_config" "1"

test_name 'verify that sed was still called'
assert "stub_valled_times sed" "1"

clean





assert_end "$func"
