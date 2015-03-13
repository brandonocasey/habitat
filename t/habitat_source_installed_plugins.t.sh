#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_source_installed_plugins"


function setup() {
  stub 'habitat_source_file'
  stub 'habitat_is_valid_plugin_name'
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
  restore 'habitat_source_file'
  restore 'habitat_is_valid_plugin_name'
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
}


#
#
#
setup
test_name "No Authors/Plugins - No STDOUT"
assert "$func '$tmp'" ""

test_name "No Authors/Plugins - Failure"
assert_raises "$func '$tmp'" "1"

test_name "No Authors/Plugins - source not called"
$func "$tmp" 2>&1 > /dev/null
assert "stub_called_times 'habitat_source_file'" "0"

test_name "No Authors/Plugins - plugin validation not called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "0"

clean



#
#
#
setup "author"
test_name "1 Authors 0 Plugins - No STDOUT"
assert "$func '$tmp'" ""

test_name "1 Authors 0 Plugins - Success"
assert_raises "$func '$tmp'" "0"

test_name "1 Authors 0 Plugins - source not called"
$func "$tmp" 2>&1 > /dev/null
assert "stub_called_times 'habitat_source_file'" "0"

test_name "1 Author 0 Plugins - plugin validation not called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "0"

clean


#
#
#
setup "author" "plugin"
test_name "1 Authors 1 Plugins - STDOUT"
assert "$func '$tmp'" "author_plugin"

test_name "1 Authors 1 Plugins - Success"
assert_raises "$func '$tmp'" "0"


test_name "1 Authors 1 Plugins - source called"
$func "$tmp" 2>&1 > /dev/null
assert "stub_called_times 'habitat_source_file'" "1"

test_name "1 Author 1 Plugin - plugin validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean

#
#
#
setup "author" "plugin" "author" "plugin2"
test_name "1 Authors 2 Plugins - STDOUT"
assert "$func '$tmp'" "author_plugin\nauthor_plugin2"

test_name "1 Authors 2 Plugins - Success"
assert_raises "$func '$tmp'" "0"


test_name "1 Authors 2 Plugins - source called"
$func "$tmp" 2>&1 > /dev/null
assert "stub_called_times 'habitat_source_file'" "2"

test_name "1 Author 2 Plugin - plugin validation called twice"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "2"

clean



#
#
#
setup "author" "plugin" "author2"
test_name "2 Authors 1 Plugin - STDOUT"
assert "$func '$tmp'" "author_plugin"

test_name "2 Authors 1 Plugin - Success"
assert_raises "$func '$tmp'" "0"


test_name "2 Authors 1 Plugin - source called"
$func "$tmp" 2>&1 > /dev/null
assert "stub_called_times 'habitat_source_file'" "1"

test_name "2 Author 1 Plugin - plugin validation called once"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean


#
#
#
setup "author" "plugin" "author2" "plugin2"
test_name "2 Authors 1 Plugin Each - STDOUT"
assert "$func '$tmp'" "author_plugin\nauthor2_plugin2"

test_name "2 Authors 1 Plugin Each - Success"
assert_raises "$func '$tmp'" "0"


test_name "2 Authors 1 Plugin Each - source called"
$func "$tmp" 2>&1 > /dev/null
assert "stub_called_times 'habitat_source_file'" "2"

test_name "2 Author 1 Plugin Each - plugin validation called twice"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "2"

clean


#
#
#
setup "author" "plugin" "author" "plugin2" "author2" "plugin" "author2" "plugin2"
test_name "2 Authors 2 Plugin Each - STDOUT"
assert "$func '$tmp'" "author_plugin\nauthor_plugin2\nauthor2_plugin\nauthor2_plugin2"

test_name "2 Authors 2 Plugin Each - Success"
assert_raises "$func '$tmp'" "0"

test_name "2 Authors 2 Plugin Each - source called"
$func "$tmp" 2>&1 > /dev/null
assert "stub_called_times 'habitat_source_file'" "4"

test_name "2 Author 2 Plugin Each - plugin validation called 4 times"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "4"

clean


# Verify validation returing false
setup "author" "plugin" "author" "plugin2"
# need to make it return false for these tests
restore 'habitat_is_valid_plugin_name'
stub_and_eval 'habitat_is_valid_plugin_name' "return 1"

test_name "1 Authors 2 Plugins, all invalid - STDOUT"
assert "$func '$tmp'" ""

test_name "1 Authors 2 Plugins, all invalid - Success"
assert_raises "$func '$tmp'" "0"


test_name "1 Authors 2 Plugins, all invalid - source not called"
$func "$tmp" 2>&1 > /dev/null
assert "stub_called_times 'habitat_source_file'" "0"

test_name "1 Author 2 Plugin, all invalid - plugin validation called twice"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "2"

clean




assert_end "$func"
