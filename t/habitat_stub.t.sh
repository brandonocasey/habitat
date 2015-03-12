#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_stub"

# TODO: File already exists check



function setup() {
  stub "habitat_is_valid_plugin_name"
}
function clean() {
  if [ -d "$tmp" ]; then
    rm -rf "$tmp"/*
  fi
  restore "habitat_is_valid_plugin_name"
}


#
#
#
setup
plugin=""
installation_dir=""
test_name "no plugin and no installation dir passed - failure"
$func "$installation_dir" "$plugin"
code="$?"
assert "echo '$code'" "1"

test_name "no plugin/installation - plugin name validation not called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "0"

clean

#
#
#
setup
plugin=""
installation_dir="$tmp"
test_name "installation dir passed no plugin passed - failure"
$func "$installation_dir" "$plugin"
code="$?"
assert "echo '$code'" "1"

test_name "no plugin - plugin name validation not called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "0"

clean

#
#
#
setup
plugin="nope/nope"
installation_dir="$tmp"
test_name "installation dir passed and valid plugin passed - success"
$func "$installation_dir" "$plugin"
code="$?"
assert "echo '$code'" "0"

test_name "Plugin file should now exist - Success"
assert_raises "test -f '$tmp/$plugin'" "0"

test_name "plugin/install - plugin name validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean

#
#
#
setup
plugin="nope/nope"
installation_dir="$tmp"
test_name "installation/plugin but already exists with content - failure"
mkdir "$tmp/$(dirname "$plugin")"
echo "Content" > "$installation_dir/$plugin"
$func "$installation_dir" "$plugin"
code="$?"
assert "echo '$code'" "1"

test_name "plugin/install - plugin name validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean

#
#
#
setup
plugin="nope/nope"
installation_dir="$tmp"
test_name "installation/plugin but already exists without content - success"
mkdir "$tmp/$(dirname "$plugin")"
touch "$installation_dir/$plugin"
$func "$installation_dir" "$plugin"
code="$?"
assert "echo '$code'" "0"

test_name "plugin/install - plugin name validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean



#
#
#
setup
# need to make it return false for these tests
restore 'habitat_is_valid_plugin_name'
stub_and_eval 'habitat_is_valid_plugin_name' "return 1"

plugin="nope/"
installation_dir="$tmp"
test_name "installation dir passed and invalid plugin passed - failure"
$func "$installation_dir" "$plugin"
code="$?"
assert "echo '$code'" "1"

test_name "plugin/install but invalid - plugin name validation called"
assert "stub_called_times 'habitat_is_valid_plugin_name'" "1"

clean







assert_end "$func"
