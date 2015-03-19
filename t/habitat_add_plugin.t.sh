#!/usr/bin/env bash
source "$(dirname "$0")/test-helper.sh" "$0" "$@"
func="habitat_add_plugin"

function setup() {
  stub 'habitat_write_config'
  stub 'habitat_read_config'
  stub 'habitat_clone_plugin_repo'
}
function clean() {
  restore 'habitat_write_config'
  restore 'habitat_read_config'
  restore 'habitat_clone_plugin_repo'
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

restore 'habitat_clone_plugin_repo'
stub_and_eval 'habitat_clone_plugin_repo' 'return 1'
test_name 'Three Args Clone Plugin Repo Fails - Failure'
assert_raises "$func '1' '$tmp' 'author/plugin'" "1"

clean

#
#
#
setup
$func '1' "$tmp" 'author/name'
code="$?"
test_name 'Add a plugin dont save to config'
assert "echo '$code'" "0"

test_name 'verify that habitat_clone_plugin_repo is called'
assert "stub_called_times 'habitat_clone_plugin_repo'" "1"

# TODO: Find out how to test this one
# test_name 'verify habitat_read_config was not called'
# assert "stub_called_times 'habitat_read_config'" "0"

test_name 'verify habitat_write_config was not called'
assert "stub_called_times 'habitat_write_config'" "0"

clean

#
#
#
setup
$func 'config.cfg' "$tmp" 'author/name'
code="$?"
test_name 'Add a plugin save to config'
assert "echo '$code'" "0"

test_name 'verify that habitat_clone_plugin_repo is called'
assert "stub_called_times 'habitat_clone_plugin_repo'" "1"

# TODO: Find out how to test this one
# test_name 'verify habitat_read_config was called'
# assert "stub_called_times 'habitat_read_config'" "1"

test_name 'verify habitat_write_config was called'
assert "stub_called_times 'habitat_write_config'" "1"


clean


assert_end "$func"
